$(document).on "page:change page:restore", -> 
  
  # Render signup/login form errors
  $("#new_user").on "ajax:error", (e, data, status, xhr) ->
    $("#new_user form").render_form_errors('user', 
      'error-message signup-error',
      $.parseJSON(data.responseText))
  
  # Render edit form errors
  $(".edit_user").on "ajax:error", (e, data, status, xhr) ->
    $(".edit_user form").render_form_errors('user', 
      'error-message user-edit-error',
      $.parseJSON(data.responseText))
  
  # Clear errors when form is submitted again    
  $(".edit_user").on "submit", ->
    $(".edit_user form").clear_form_errors()
    
  # Focus on signup form when help modal closes
  $('#help-modal').on 'hidden.bs.modal', ->
    $('#user_email').focus()
    
  $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
    target = $(e.target).data("save")
    $('.toggle-save:visible').hide()
    $('#'+target).show()