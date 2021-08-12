Deface::Override.new(
  virtual_path:  'spree/admin/shared/_order_summary',
  name:          'add_pluggto_id_to_order_summary',
  insert_bottom: '[id="order_tab_summary"]'
) do
  <<-HTML
  <% if @order.pluggto_id %>
  <tr>
    <td><strong>Plugg.to id</strong></td>
    <td><%= @order.pluggto_id %></td>
  </tr>
  <% end %>
  HTML
end
