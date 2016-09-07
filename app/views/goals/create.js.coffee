$('#new_goal_modal').modal('hide')
newgoal = $("<%= j render partial: 'goals/want_goal', 
            object: @goal, as: :goal %>")
            .prependTo('#goals-section')
