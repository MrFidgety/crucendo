$(document).on "page:change page:restore", ->
  # Render contact form errors
  $("#new_general_contact").on "ajax:error", (e, data, status, xhr) ->
    $("#new_general_contact form").render_form_errors('contact', 
      'error-message goal-error',
      $.parseJSON(data.responseText))
      
  $("#new_business_contact").on "ajax:error", (e, data, status, xhr) ->
    $("#new_business_contact form").render_form_errors('contact', 
      'error-message goal-error',
      $.parseJSON(data.responseText))