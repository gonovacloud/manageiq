module NOVAHawk::Providers::Inflector::Methods
  extend ActiveSupport::Concern

  included do
    include ClassMethods
  end

  class_methods do
    def provider_name
      NOVAHawk::Providers::Inflector.provider_name(self)
    end

    def manager_type
      NOVAHawk::Providers::Inflector.manager_type(self)
    end
  end
end
