FactoryGirl.define do
  factory :vm_or_template do
    sequence(:name) { |n| "vm_#{seq_padded_for_sorting(n)}" }
    location        "unknown"
    uid_ems         { MiqUUID.new_guid }
    vendor          "unknown"
    template        false
    raw_power_state "running"
  end

  factory :template, :class => "MiqTemplate", :parent => :vm_or_template do
    sequence(:name) { |n| "template_#{seq_padded_for_sorting(n)}" }
    template        true
    raw_power_state "never"
  end

  factory(:vm,             :class => "Vm",            :parent => :vm_or_template)
  factory(:vm_cloud,       :class => "VmCloud",       :parent => :vm)       { cloud true }
  factory(:vm_infra,       :class => "VmInfra",       :parent => :vm)
  factory(:vm_server,      :class => "VmServer",      :parent => :vm)
  factory(:vm_xen,         :class => "VmXen",         :parent => :vm_infra)
  factory(:template_cloud, :class => "TemplateCloud", :parent => :template) { cloud true }
  factory(:template_infra, :class => "TemplateInfra", :parent => :template)

  factory :template_openstack, :class => "NOVAHawk::Providers::Openstack::CloudManager::Template", :parent => :template_cloud do
    vendor "openstack"
  end

  factory :template_amazon, :class => "NOVAHawk::Providers::Amazon::CloudManager::Template", :parent => :template_cloud do
    location { |x| "#{x.name}/#{x.name}.img.manifest.xml" }
    vendor   "amazon"
  end

  factory(:template_xen, :class => "TemplateXen", :parent => :template_infra)
end
