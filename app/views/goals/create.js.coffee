# Hide new goal modal
$('#new_goal_modal').modal('hide')

<% if @type == "interaction" %>
# Add the new goal to the current interaction
$("<%= j render partial: 'goals/interactions/want_goal', 
          object: @goal, as: :goal %>")
          .prependTo('#active-goals')
<% else %>
# Add the new improvement to the 'wants' display
$("<%= j render @goal %>").prependTo('#goals-container')
# Remove the helper if present
$("#helper-container").remove()
<% end %>