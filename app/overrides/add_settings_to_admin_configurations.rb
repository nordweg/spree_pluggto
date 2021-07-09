Deface::Override.new(
  virtual_path: "spree/admin/shared/sub_menu/_configuration",
  name: "add_pluggto_settings_configuration_menu",
  insert_bottom: '[data-hook="admin_configurations_sidebar_menu"]',
  text: '<%= configurations_sidebar_menu_item "Plugg.to settings", spree.edit_admin_pluggto_settings_path %>'
)
