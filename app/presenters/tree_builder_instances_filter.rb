class TreeBuilderInstancesFilter < TreeBuilderVmsFilter
  def tree_init_options(_tree_name)
    super.update(:leaf => 'NOVAHawk::Providers::CloudManager::Vm')
  end

  def set_locals_for_render
    locals = super
    locals.merge!(
      :tree_id   => "instances_filter_treebox",
      :tree_name => "instances_filter_tree",
      :autoload  => false
    )
  end

  def root_options
    [_("All Instances"), _("All of the Instances that I can see")]
  end
end
