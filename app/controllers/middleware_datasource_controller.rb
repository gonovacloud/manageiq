class MiddlewareDatasourceController < ApplicationController
  include EmsCommon
  include MiddlewareCommonMixin

  before_action :check_privileges
  before_action :get_session_data
  after_action :cleanup_action
  after_action :set_session_data

  OPERATIONS = {
    :middleware_datasource_remove => {
      :op       => :remove_middleware_datasource,
      :skip     => true,
      :hawk     => N_('removed datasources'),
      :skip_msg => N_('Not %{operation_name} for %{record_name} on the provider itself'),
      :msg      => N_('The selected datasources were removed')
    }
  }.freeze

  def self.operations
    OPERATIONS
  end
end
