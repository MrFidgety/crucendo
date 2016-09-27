# Hide improvement modal
$('#new_improvement_modal').modal('hide')

<% if @type == "interaction" %>
# Add the goal improvement to the current interaction
$("<%= j render partial: 'goals/interactions/have_goal', object: @goal, 
    as: :goal, locals: {improvement: @improvement, interaction_id: @goal.interaction_id} %>")
    .prependTo('#improved-goals')
<% else %>
# Add the new improvement to the 'haves' display
$("<%= j render(@improvement, selectable: true) %>").prependTo('#improved-goals')
# Remove the helper if present
$(".improvement-helper").remove()
<% end %>