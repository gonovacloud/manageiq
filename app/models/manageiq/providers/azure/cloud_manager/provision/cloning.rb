module NOVAHawk::Providers::Azure::CloudManager::Provision::Cloning
  def do_clone_task_check(clone_task_ref)
    source.with_provider_connection do |azure|
      vms      = Azure::Armrest::VirtualMachineService.new(azure)
      instance = vms.get(clone_task_ref[:vm_name], clone_task_ref[:vm_resource_group])
      status   = instance.properties.provisioning_state
      return true if status == "Succeeded"
      return false, status
    end
  end

  def find_destination_in_vmdb(vm_uid_hash)
    ems_ref = vm_uid_hash.values.join("\\")
    NOVAHawk::Providers::Azure::CloudManager::Vm.find_by(:ems_ref => ems_ref.downcase)
  end

  def gather_storage_account_properties
    sas = nil

    source.with_provider_connection do |azure|
      sas = Azure::Armrest::StorageAccountService.new(azure)
    end

    return if sas.nil?

    begin
      image = sas.list_private_images(storage_account_resource_group).find do |img|
        img.uri == source.ems_ref
      end

      return unless image

      platform   = image.operating_system
      endpoint   = image.storage_account.properties.primary_endpoints.blob
      source_uri = image.uri

      target_uri = File.join(endpoint, "novahawk", dest_name + "_" + SecureRandom.uuid + ".vhd")
    rescue Azure::Armrest::ResourceNotFoundException => err
      _log.error("Error Class=#{err.class.name}, Message=#{err.message}")
    end

    return target_uri, source_uri, platform
  end

  def custom_data
    userdata_payload.encode('UTF-8').delete("\n")
  end

  def prepare_for_clone_task
    nic_id = associated_nic || create_nic

    # TODO: Ideally this would be a check against source.storage or source.disks
    if source.ems_ref.starts_with?('/subscriptions')
      os = source.operating_system.product_name
      target_uri, source_uri = nil
    else
      target_uri, source_uri, os = gather_storage_account_properties
    end

    cloud_options =
    {
      :name       => dest_name,
      :location   => source.location,
      :properties => {
        :hardwareProfile => {
          :vmSize => instance_type.name
        },
        :osProfile       => {
          :adminUserName => options[:root_username],
          :adminPassword => root_password,
          :computerName  => dest_hostname
        },
        :storageProfile  => {
          :osDisk        => {
            :createOption => 'FromImage',
            :caching      => 'ReadWrite',
            :osType       => os
          }
        },
        :networkProfile  => {
          :networkInterfaces => [{:id => nic_id}],
        }
      }
    }

    if target_uri
      cloud_options[:properties][:storageProfile][:osDisk][:name]  = dest_name + SecureRandom.uuid + '.vhd'
      cloud_options[:properties][:storageProfile][:osDisk][:image] = {:uri => source_uri}
      cloud_options[:properties][:storageProfile][:osDisk][:vhd]   = {:uri => target_uri}
    else
      # Default to a storage account type of "Standard_LRS" for managed images for now.
      cloud_options[:properties][:storageProfile][:osDisk][:managedDisk] = {:storageAccountType => 'Standard_LRS'}
      cloud_options[:properties][:storageProfile][:imageReference] = {:id => source.ems_ref}
    end

    cloud_options[:properties][:osProfile][:customData] = custom_data unless userdata_payload.nil?
    cloud_options
  end

  def log_clone_options(clone_options)
    dumpObj(clone_options, "#{_log.prefix} Clone Options: ", $log, :info)
    dumpObj(options, "#{_log.prefix} Prov Options:  ", $log, :info, :protected =>
    {:path => workflow_class.encrypted_options_field_regs})
  end

  def region
    source.location
  end

  def storage_account_resource_group
    source.description.split("\\").first
  end

  def storage_account_name
    source.description.split("\\")[1]
  end

  def associated_nic
    floating_ip.try(:network_port).try(:ems_ref)
  end

  def create_nic
    source.with_provider_connection do |azure|
      nis             = Azure::Armrest::Network::NetworkInterfaceService.new(azure)
      ips             = Azure::Armrest::Network::IpAddressService.new(azure)
      ip              = ips.create("#{dest_name}-publicIp", resource_group.name, :location => region)
      network_options = build_nic_options(ip.id)

      return nis.create(dest_name, resource_group.name, network_options).id
    end
  end

  def build_nic_options(ip)
    network_options = {
      :location   => region,
      :properties => {
        :ipConfigurations => [
          :name       => dest_name,
          :properties => {
            :subnet          => {
              :id => cloud_subnet.ems_ref
            },
            :publicIPAddress => {
              :id => ip
            },
          }
        ],
      }
    }
    network_options[:properties][:networkSecurityGroup] = {:id => security_group.ems_ref} if security_group
    network_options
  end

  def start_clone(clone_options)
    source.with_provider_connection do |azure|
      vms = Azure::Armrest::VirtualMachineService.new(azure)
      vm  = vms.create(dest_name, resource_group.name, clone_options)

      {
        :subscription_id   => azure.subscription_id,
        :vm_resource_group => vm.resource_group,
        :type              => vm.type.downcase,
        :vm_name           => vm.name
      }
    end
  end
end
