<% if @type == "interaction" %>
# Replace goal panel
$('#goal_<%= @goal.id %>').replaceWith(
  "<%= j render partial: 'goals/interactions/want_goal', 
  object: @goal, as: :goal %>")
# Hide edit modal
$('#edit_goal_modal').modal('hide')
<% end %>
# Render flash
$("#flash-container").html("<%= j render_flash %>").stop().hide().fadeIn ->
  $(this).delay(3000).fadeOut()