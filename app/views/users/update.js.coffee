# Render any flash set during AJAX call
$("#flash-container").html("<%= j render_flash %>").hide().fadeIn ->
  $(this).delay(3000).fadeOut()

# Clear new password fields
$("#user_password, #user_password_confirmation").val('')

# Update 'current password' field if password was set
$("#current_password").replaceWith("<%= j render partial: 'users/current_password' %>")