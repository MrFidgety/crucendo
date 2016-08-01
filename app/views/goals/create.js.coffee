$('#new_goal_modal').modal('hide')
newgoal = $("<%= j render @goal %>").hide().fadeIn();
$('#goals').append(newgoal)