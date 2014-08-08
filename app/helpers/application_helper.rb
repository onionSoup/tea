module ApplicationHelper
  def render_form_errors(object)
    return if object.nil? || object.errors.empty?
    render inline: <<-'EOM', type: :erb, locals: {object: object}
  <ul id= "error_message_ul">
    <% object.errors.values.flatten.each do |msg| %>
      <li class="error_message_li"><%= msg %></li>
    <% end %>
  </ul>
    EOM
  end

  def path_to_admin_user_detail(user_id, detail_id)
    "/admin/users/#{user_id}/order_details/#{detail_id}:id"
  end
end
