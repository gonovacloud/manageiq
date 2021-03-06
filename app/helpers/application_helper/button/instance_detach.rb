class ApplicationHelper::Button::InstanceDetach < ApplicationHelper::Button::Basic
  def calculate_properties
    super
    self[:title] = @error_message if disabled?
  end

  def disabled?
    if @record.number_of(:cloud_volumes).zero?
      @error_message = _("This Instance has no attached Cloud Volumes.")
    end
    @error_message.present?
  end
end
