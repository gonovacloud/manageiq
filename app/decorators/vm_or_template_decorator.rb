class VmOrTemplateDecorator < Draper::Decorator
  delegate_all

  def fonticon
    nil
  end

  def listicon_image
    "svg/vendor-#{vendor.downcase}.svg"
  end

  def supports_console?
    console_supported?('spice') || console_supported?('vnc')
  end

  def supports_vnc_console?
    console_supported?('vnc')
  end

  def supports_cockpit?
    supports_launch_cockpit?
  end
end
