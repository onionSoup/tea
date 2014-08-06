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
end
