class CloudTenant < ApplicationRecord
  TENANT_MAPPING_ASSOCIATIONS = %i(vms_and_templates).freeze

  include NewWithTypeStiMixin
  include VirtualTotalMixin
  extend ActsAsTree::TreeWalker

  belongs_to :ext_management_system, :foreign_key => "ems_id", :class_name => "NOVAHawk::Providers::CloudManager"
  has_one    :source_tenant, :as => :source, :class_name => 'Tenant'
  has_many   :security_groups
  has_many   :cloud_networks
  has_many   :cloud_subnets
  has_many   :network_ports
  has_many   :network_routers
  has_many   :vms
  has_many   :vms_and_templates
  has_many   :miq_templates
  has_many   :floating_ips
  has_many   :cloud_volumes
  has_many   :cloud_volume_backups
  has_many   :cloud_volume_snapshots
  has_many   :cloud_object_store_containers
  has_many   :cloud_object_store_objects
  has_many   :cloud_resource_quotas
  has_many   :cloud_tenant_flavors, :dependent => :destroy
  has_many   :flavors, :through => :cloud_tenant_flavors

  alias_method :direct_cloud_networks, :cloud_networks

  acts_as_miq_taggable

  acts_as_tree :order => 'name'

  virtual_total :total_vms, :vms

  def self.scope_by_cloud_tenant?
    true
  end

  def self.accessible_tenant_ids(user_or_group, strategy)
    tenant = user_or_group.try(:current_tenant)
    return [] if tenant.nil? || tenant.root?

    tenant.accessible_tenant_ids(strategy)
  end

  def self.tenant_id_clause(user_or_group)
    tenant_ids = accessible_tenant_ids(user_or_group, Rbac.accessible_tenant_ids_strategy(self))
    return if tenant_ids.empty?

    ["(tenants.id IN (?) AND ext_management_systems.tenant_mapping_enabled IS TRUE) OR ext_management_systems.tenant_mapping_enabled IS FALSE OR ext_management_systems.tenant_mapping_enabled IS NULL", tenant_ids]
  end

  def self.tenant_joins_clause(scope)
    scope.eager_load(:source_tenant).includes(:ext_management_system)
  end

  def self.class_by_ems(ext_management_system)
    ext_management_system && ext_management_system.class::CloudTenant
  end

  def self.create_cloud_tenant(ems_id, options = {})
    ext_management_system = ExtManagementSystem.find_by_id(ems_id)
    raise ArgumentError, _("ext_management_system cannot be nil") if ext_management_system.nil?

    klass = class_by_ems(ext_management_system)
    created_cloud_tenant = klass.raw_create_cloud_tenant(ext_management_system, options)
  end

  def self.raw_create_cloud_tenant(_ext_management_system, _options = {})
    raise NotImplementedError, _("raw_create_cloud_tenant must be implemented in a subclass")
  end

  def self.create_cloud_tenant_queue(userid, ext_management_system, options = {})
    task_opts = {
      :action => "creating Cloud Tenant for user #{userid}",
      :userid => userid
    }
    queue_opts = {
      :class_name  => self.class_by_ems(ext_management_system),
      :method_name => 'create_cloud_tenant',
      :priority    => MiqQueue::HIGH_PRIORITY,
      :role        => 'ems_operations',
      :zone        => ext_management_system.my_zone,
      :args        => [ext_management_system.id, options]
    }
    MiqTask.generic_action_with_callback(task_opts, queue_opts)
  end

  def update_cloud_tenant(options = {})
    raw_update_cloud_tenant(options)
  end

  def raw_update_cloud_tenant(_options = {})
    raise NotImplementedError, _("raw_update_cloud_tenant must be implemented in a subclass")
  end

  def update_cloud_tenant_queue(userid, options = {})
    task_opts = {
      :action => "updating Cloud Tenant for user #{userid}",
      :userid => userid
    }
    queue_opts = {
      :class_name  => self.class.name,
      :method_name => 'update_cloud_tenant',
      :instance_id => id,
      :priority    => MiqQueue::HIGH_PRIORITY,
      :role        => 'ems_operations',
      :zone        => ext_management_system.my_zone,
      :args        => [options]
    }
    MiqTask.generic_action_with_callback(task_opts, queue_opts)
  end

  def delete_cloud_tenant
    raw_delete_cloud_tenant
  end

  def raw_delete_cloud_tenant
    raise NotImplementedError, _("raw_delete_cloud_tenant must be implemented in a subclass")
  end

  def delete_cloud_tenant_queue(userid)
    task_opts = {
      :action => "deleting Cloud Tenant for user #{userid}",
      :userid => userid
    }
    queue_opts = {
      :class_name  => self.class.name,
      :method_name => 'delete_cloud_tenant',
      :instance_id => id,
      :priority    => MiqQueue::HIGH_PRIORITY,
      :role        => 'ems_operations',
      :zone        => ext_management_system.my_zone,
      :args        => []
    }
    MiqTask.generic_action_with_callback(task_opts, queue_opts)
  end

  def all_cloud_networks
    direct_cloud_networks + shared_cloud_networks
  end

  def shared_cloud_networks
    try(:ext_management_system).try(:cloud_networks).try(:where, :shared => true) || []
  end

  def update_source_tenant_associations
    TENANT_MAPPING_ASSOCIATIONS.each do |tenant_association|
      custom_update_method = "#{__method__}_for_#{tenant_association}"

      if respond_to?(custom_update_method)
        public_send(custom_update_method)
      end
    end
  end

  def update_source_tenant_associations_for_vms_and_templates
    vms_and_templates.each do |object|
      object.miq_group_id = source_tenant.default_miq_group_id
      object.save!
    end
  end

  def self.with_ext_management_system(ems_id)
    where(:ext_management_system => ems_id)
  end

  def self.post_refresh_ems(ems_id, _)
    ems = ExtManagementSystem.find(ems_id)

    MiqQueue.put_unless_exists(
      :class_name  => ems.class,
      :instance_id => ems_id,
      :method_name => 'sync_cloud_tenants_with_tenants',
      :zone        => ems.my_zone
    ) if ems.supports_cloud_tenant_mapping?
  end
end
