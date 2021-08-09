Deface::Override.new(
  virtual_path:  'spree/admin/shared/_product_tabs',
  name:          'add_pluggto_tab_to_order_sidebar',
  insert_bottom: '[data-hook="admin_product_tabs"]'
) do
  <<-HTML
  <%= content_tag :li, class: ('active' if current == :pluggto_fields) do %>
    <%= link_to_with_icon "transfer", "Plugg.to", spree.admin_product_pluggto_fields_url(@product) %>
  <% end %>
  HTML
end
