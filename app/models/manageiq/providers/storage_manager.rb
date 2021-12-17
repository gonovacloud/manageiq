#
# StorageManager (hsong)
#
#

module NOVAHawk::Providers
  class StorageManager < NOVAHawk::Providers::BaseManager
    include SupportsFeatureMixin
    supports_not :smartstate_analysis

    belongs_to :parent_manager,
               :foreign_key => :parent_ems_id,
               :class_name  => "NOVAHawk::Providers::BaseManager",
               :autosave    => true
  end
end
