class ApplicationHelper::Toolbar::TemplateCloudsCenter < ApplicationHelper::Toolbar::Basic
  button_group('image_vmdb', [
                 select(
                   :image_vmdb_choice,
                   'fa fa-cog fa-lg',
                   t = N_('Configuration'),
                   t,
                   :enabled => false,
                   :onwhen  => "1+",
                   :items   => [
                     button(
                       :image_refresh,
                       'fa fa-refresh fa-lg',
                       N_('Refresh relationships and power states for all items related to the selected items'),
                       N_('Refresh Relationships and Power States'),
                       :url_parms => "main_div",
                       # rubocop:disable LineLength
                       :confirm   => N_("Refresh relationships and power states for all items related to the selected items?"),
                       :enabled   => false,
                       :onwhen    => "1+"),
                     button(
                       :image_scan,
                       'fa fa-search fa-lg',
                       N_('Perform SmartState Analysis on the selected items'),
                       N_('Perform SmartState Analysis'),
                       :url_parms => "main_div",
                       :confirm   => N_("Perform SmartState Analysis on the selected items?"),
                       :enabled   => false,
                       :onwhen    => "1+"),
                     button(
                       :image_compare,
                       'product product-compare fa-lg',
                       N_('Select two or more items to compare'),
                       N_('Compare Selected items'),
                       :url_parms => "main_div",
                       :enabled   => false,
                       :onwhen    => "2+"),
                     separator,
                     button(
                       :image_edit,
                       'pficon pficon-edit fa-lg',
                       N_('Select a single item to edit'),
                       N_('Edit Selected item'),
                       :url_parms => "main_div",
                       :enabled   => false,
                       :onwhen    => "1"),
                     button(
                       :image_ownership,
                       'pficon pficon-user fa-lg',
                       N_('Set Ownership for the selected items'),
                       N_('Set Ownership'),
                       :url_parms => "main_div",
                       :enabled   => false,
                       :onwhen    => "1+"),
                     button(
                       :image_delete,
                       'pficon pficon-delete fa-lg',
                       t = N_('Remove selected items'),
                       t,
                       :url_parms => "main_div",
                       # rubocop:disable LineLength
                       :confirm   => N_("Warning: The selected items and ALL of their components will be permanently removed!"),
                       :enabled   => false,
                       :onwhen    => "1+"),
                     separator,
                     button(
                       :image_right_size,
                       'product product-custom-6 fa-lg',
                       N_('CPU/Memory Recommendations of selected item'),
                       N_('Right-Size Recommendations'),
                       :url_parms => "main_div",
                       :enabled   => false,
                       :onwhen    => "1"),
                     button(
                       :image_reconfigure,
                       'pficon pficon-edit fa-lg',
                       N_('Reconfigure the Memory/CPUs of selected items'),
                       N_('Reconfigure Selected items'),
                       :url_parms => "main_div",
                       :enabled   => false,
                       :onwhen    => "1+"),
                   ]
                 ),
               ])
  button_group('image_lifecycle', [
                 select(
                   :image_lifecycle_choice,
                   'pficon pficon-add-circle-o fa-lg',
                   t = N_('Lifecycle'),
                   t,
                   :items => [
                     button(
                       :image_miq_request_new,
                       'product product-clone fa-lg',
                       N_('Select a single Image to Provision Instances'),
                       N_('Provision Instances using selected Image'),
                       :url_parms => "main_div",
                       :enabled   => false,
                       :onwhen    => "1"),
                   ]
                 ),
               ])
  button_group('image_policy', [
                 select(
                   :image_policy_choice,
                   'fa fa-shield fa-lg',
                   t = N_('Policy'),
                   t,
                   :enabled => false,
                   :onwhen  => "1+",
                   :items   => [
                     button(
                       :image_protect,
                       'pficon pficon-edit fa-lg',
                       N_('Manage Policies for the selected items'),
                       N_('Manage Policies'),
                       :url_parms => "main_div",
                       :enabled   => false,
                       :onwhen    => "1+"),
                     button(
                       :image_policy_sim,
                       'fa fa-play-circle-o fa-lg',
                       N_('View Policy Simulation for the selected items'),
                       N_('Policy Simulation'),
                       :url_parms => "main_div",
                       :enabled   => false,
                       :onwhen    => "1+"),
                     button(
                       :image_tag,
                       'pficon pficon-edit fa-lg',
                       N_('Edit tags for the selected items'),
                       N_('Edit Tags'),
                       :url_parms => "main_div",
                       :enabled   => false,
                       :onwhen    => "1+"),
                     button(
                       :image_check_compliance,
                       'fa fa-search fa-lg',
                       N_('Check Compliance of the last known configuration for the selected items'),
                       N_('Check Compliance of Last Known Configuration'),
                       :url_parms => "main_div",
                       # rubocop:disable LineLength
                       :confirm   => N_("Initiate Check Compliance of the last known configuration for the selected items?"),
                       :enabled   => false,
                       :onwhen    => "1+"),
                   ]
                 ),
               ])
end
