$('#new_improvement_modal').modal('hide')
$("<%= j render partial: 'goals/have_goal', object: @goal, 
    as: :goal, locals: {interaction: @interaction, initial: ''} %>")
            .appendTo('#improved-goals').hide().slideDown('slow')