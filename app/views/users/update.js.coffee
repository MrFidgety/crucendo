# Render any flash set during AJAX call
$("#primary-container").prepend("<%= j render_flash %>")

# Clear new password fields
$("#user_password, #user_password_confirmation").val('')

# Update 'current password' field if password was set
$("#current_password").replaceWith("<%= j render partial: 'users/current_password' %>")