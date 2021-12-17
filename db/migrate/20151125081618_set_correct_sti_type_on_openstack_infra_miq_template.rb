class SetCorrectStiTypeOnOpenstackInfraMiqTemplate < ActiveRecord::Migration
  class ExtManagementSystem < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  class Vm < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end

  def up
    # Set OpenStack Infra specific STI types for miq_template under that provider
    Vm.joins('join ext_management_systems on vms.ems_id = ext_management_systems.id').
      where(vms:                    { type: 'NOVAHawk::Providers::Openstack::CloudManager::Template'},
            ext_management_systems: { type: 'NOVAHawk::Providers::Openstack::InfraManager'}).
      update_all("type = 'NOVAHawk::Providers::Openstack::InfraManager::Template'")
  end

  def down
    # Set back Openstack cloud specific STI types for miq_template under infra that provider
    Vm.joins('join ext_management_systems on vms.ems_id = ext_management_systems.id').
      where(vms:                    { type: 'NOVAHawk::Providers::Openstack::InfraManager::Template'},
            ext_management_systems: { type: 'NOVAHawk::Providers::Openstack::InfraManager'}).
      update_all("type = 'NOVAHawk::Providers::Openstack::CloudManager::Template'")
  end
end
