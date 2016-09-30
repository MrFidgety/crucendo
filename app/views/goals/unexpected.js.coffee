# Hide improvement modal
$('#new_improvement_modal').modal('hide')

<% if @type == "interaction" %>
# Add the goal improvement to the current interaction
$("<%= j render partial: 'goals/interactions/have_goal', object: @goal, 
    as: :goal, locals: {improvement: @improvement, interaction_id: @goal.interaction_id} %>")
    .prependTo('#improved-goals')
<% else %>
# Add the new improvement to the 'haves' display
$("<%= j render(@improvement, selectable: true) %>").prependTo('#improvements-container')
# Remove the helper if present
$("#helper-container").remove()
<% end %>
# Render flash
$("#flash-container").html("<%= j render_flash %>").stop().hide().fadeIn ->
  $(this).delay(3000).fadeOut()