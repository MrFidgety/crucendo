# Fill edit modal with this specific goals edit form
$("#edit_goal_modal").html(
  "<%= j render partial: 'goals/interactions/edit_want_modal', 
  object: @goal, as: :goal %>")
# Show the edit modal
$('#edit_goal_modal').modal('show')

# Fix ios safari issue with clearing date value
$('[type="date"]').focus (e) ->
  e.currentTarget.defaultValue = ''