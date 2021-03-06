class FixForemanProviderType < ActiveRecord::Migration
  include MigrationHelper

  NAME_MAP = Hash[*%w(
    ProviderForeman                    NOVAHawk::Providers::Foreman::Provider
  )]

  def change
    say_with_time "Rename class references for Foreman" do
      rename_class_references(NAME_MAP)
    end
  end
end
