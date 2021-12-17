# An availability zone to represent the cases where Openstack VMs may be
# launched into no availability zone
class NOVAHawk::Providers::Openstack::CloudManager::AvailabilityZoneNull < NOVAHawk::Providers::Openstack::CloudManager::AvailabilityZone
  default_value_for :name,   "No Availability Zone"
end
