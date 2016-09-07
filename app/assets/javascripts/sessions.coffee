$(document).on "page:change page:restore", -> 

  # render login password form errors (listener on body as content is dynamic)
  $(document.body).on "ajax:error", "#new_session", (e, data, status, xhr) ->
    $("#new_session form").render_form_errors('session', 
      'error-message signup-error',
      $.parseJSON(data.responseText))