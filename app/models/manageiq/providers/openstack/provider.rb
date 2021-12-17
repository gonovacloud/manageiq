class NOVAHawk::Providers::Openstack::Provider < ::Provider
  has_one :infra_ems,
          :foreign_key => "provider_id",
          :class_name  => "NOVAHawk::Providers::Openstack::InfraManager",
          :autosave    => true
  has_many :cloud_ems,
           :foreign_key => "provider_id",
           :class_name  => "NOVAHawk::Providers::Openstack::CloudManager",
           :dependent   => :nullify,
           :autosave    => true
  has_many :network_managers,
           :foreign_key => "provider_id",
           :class_name  => "NOVAHawk::Providers::Openstack::NetworkManager",
           :autosave    => true

  validates :name, :presence => true, :uniqueness => true
end
