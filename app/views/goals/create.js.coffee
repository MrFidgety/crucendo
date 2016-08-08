$('#new_goal_modal').modal('hide')
newgoal = $("<%= j render partial: 'goals/want_goal', 
            object: @goal, as: :goal %>")
            .appendTo('#goals-section').hide().slideDown('slow')
