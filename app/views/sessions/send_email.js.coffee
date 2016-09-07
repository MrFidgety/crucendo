# Fade out login-module form
$('#login_module').fadeOut 600, ->
  # Create new partial based on response
  response = $("<%= j render @response_form %>").hide()
  # Replace login-module with response
  $(this).replaceWith(response)
  # Fade response in
  response.fadeIn 600