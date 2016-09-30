<% if @type == "interaction" %>
# Replace partial with updated version
$('#goal_<%= @goal.id %>').replaceWith(
  "<%= j render partial: 'goals/interactions/have_goal', 
  object: @goal, as: :goal, locals: { interaction_id: @interaction.id } %>")

# Fix the goal position if ajax call unsuccessful
new_goal = $('#goal_<%= @goal.id %>')
if new_goal.hasClass('improved')
  if new_goal.parent('#improved-goals').length == 0
    new_goal.detach().appendTo('#improved-goals') 
else
  if new_goal.parent('#all-goals').length == 0
    new_goal.detach().appendTo('#all-goals') 
<% else %>
# Hide improvement modal
$('#new_improvement_modal').modal('hide')
# Add the new improvement to the 'haves' display
$("<%= j render(@improvement) %>").prependTo('#improvements-container')
# Remove the helper if present
$("#helper-container").remove()
<% end %>
# Render flash
$("#flash-container").html("<%= j render_flash %>").stop().hide().fadeIn ->
  $(this).delay(3000).fadeOut()