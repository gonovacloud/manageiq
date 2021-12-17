module MiqAeMethodService
  class MiqAeServiceNOVAHawk_Providers_StorageManager_CinderManager < MiqAeServiceNOVAHawk_Providers_StorageManager
    expose :parent_manager,         :association => true
    expose :cloud_volumes,          :association => true
    expose :cloud_volume_snapshots, :association => true
  end
end
