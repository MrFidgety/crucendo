# replace partial with updated version
$('#goal_<%= @goal.id %>').replaceWith(
    "<%= j render partial: 'goals/have_goal', object: @goal, 
    as: :goal, locals: {interaction: @interaction} %>")