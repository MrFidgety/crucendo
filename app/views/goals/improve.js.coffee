# replace partial with updated version
old_goal = $('#goal_<%= @goal.id %>')
old_goal.replaceWith(
    "<%= j render partial: 'goals/have_goal', object: @goal, 
    as: :goal, locals: {interaction: @interaction, initial: ''} %>")

new_goal = $('#goal_<%= @goal.id %>')
# fix the goal position if ajax call unsuccessful
if new_goal.hasClass('improved')
    new_goal.detach().appendTo('#improved_goals') if new_goal.parent('#improved_goals').length == 0
else
    new_goal.detach().appendTo('#all_goals') if new_goal.parent('#all_goals').length == 0
