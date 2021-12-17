class NamespaceEmsForeman < ActiveRecord::Migration
  include MigrationHelper

  NAME_MAP = Hash[*%w(
    ConfigurationManager                        NOVAHawk::Providers::ConfigurationManager
    ProvisioningManager                         NOVAHawk::Providers::ProvisioningManager

    ProviderForeman                             NOVAHawk::Providers::Foreman::Provider
    ConfigurationManagerForeman                 NOVAHawk::Providers::Foreman::ConfigurationManager
    ConfigurationProfileForeman                 NOVAHawk::Providers::Foreman::ConfigurationManager::ConfigurationProfile
    ConfiguredSystemForeman                     NOVAHawk::Providers::Foreman::ConfigurationManager::ConfiguredSystem
    MiqProvisionConfiguredSystemForemanWorkflow NOVAHawk::Providers::Foreman::ConfigurationManager::ProvisionWorkflow
    MiqProvisionTaskConfiguredSystemForeman     NOVAHawk::Providers::Foreman::ConfigurationManager::ProvisionTask
    ProvisioningManagerForeman                  NOVAHawk::Providers::Foreman::ProvisioningManager
  )]

  def change
    rename_class_references(NAME_MAP)
  end
end
