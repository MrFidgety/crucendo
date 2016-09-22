# Replace partial with updated version
old_goal = $('#goal_<%= @goal.id %>')
old_goal.replaceWith("<%= j render partial: 'goals/interactions/have_goal', 
    object: @goal, as: :goal, locals: { interaction_id: @interaction.id } %>")

# Fix the goal position if ajax call unsuccessful
new_goal = $('#goal_<%= @goal.id %>')
if new_goal.hasClass('improved')
    if new_goal.parent('#improved-goals').length == 0
        new_goal.detach().appendTo('#improved-goals') 
else
    if new_goal.parent('#all-goals').length == 0
        new_goal.detach().appendTo('#all-goals') 
