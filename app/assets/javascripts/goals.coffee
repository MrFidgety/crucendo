$(document).on "page:change page:restore", -> 

  # Render edit form errors
  $(".edit_goal").on "ajax:error", (e, data, status, xhr) ->
    $(".edit_goal form").render_form_errors('goal', 
      'error-message user-edit-error',
      $.parseJSON(data.responseText))
  
  # Clear errors when form is submitted again    
  $(".edit_goal").on "submit", ->
    $(".edit_goal form").clear_form_errors()
    $(".alert").alert("close")
    
  # Trigger action when helper clicked
  $('.helper-button').click ->
    console.log($(this).data("helper"))
    $("#"+$(this).data("helper")).click()