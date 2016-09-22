# Hide new goal modal
$('#new_goal_modal').modal('hide')

if "<%= j @type %>" == "interaction"
  # Add the new goal to the current interaction
  $("<%= j render partial: 'goals/interactions/want_goal', 
            object: @goal, as: :goal %>")
            .prependTo('#active-goals').hide().slideDown()
else
  # Ensure the active goals tab is showing
  $('.nav-tabs a[href="#active-goals"]').tab('show')
  # Add the new improvement to the 'wants' display
  $("<%= j render @goal %>").prependTo('#active-goals').hide().slideDown()
  # Remove the helper if present
  $("#active-goals-helper").remove()