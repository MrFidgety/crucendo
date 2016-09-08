# Fade out new_user form
$('#new_user').fadeOut 600, ->
  # Create new partial based on response
  response = $("<%= j render @response_form, object: @user, as: :user %>").hide()
  # Replace form with response
  $(this).replaceWith(response)
  # Fade response in
  response.fadeIn 600, ->
    # Automatically focus on password input
    if "<%= j @response_form %>" == "password_login"
      $('#session_password').focus()
  
# Report new user signup to google conversion
if "<%= j @response_form %>" == "activation_sent"
  goog_report_conversion()