module ApplicationHelper
  def render_form_errors(object)
    return unless object.errors.any?
    render inline: <<-'EOM', type: :erb, locals: {object: object}
  <ul id= "error_message_ul">
    <% object.errors.values.flatten.each do |msg| %>
      <li class="error_message_li"><%= msg %></li>
    <% end %>
  </ul>
    EOM
  end
end
