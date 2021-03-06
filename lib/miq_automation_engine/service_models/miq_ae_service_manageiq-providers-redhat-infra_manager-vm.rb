module MiqAeMethodService
  class MiqAeServiceNOVAHawk_Providers_Redhat_InfraManager_Vm < MiqAeServiceNOVAHawk_Providers_InfraManager_Vm
    def add_disk(disk_name, disk_size_mb, options = {})
      sync_or_async_ems_operation(options[:sync], "add_disk", [disk_name, disk_size_mb, options])
    end
  end
end
