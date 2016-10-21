$(document).on "page:change page:restore", -> 

  # Render edit form errors
  $(".edit_goal").on "ajax:error", (e, data, status, xhr) ->
    $(".edit_goal form").render_form_errors('goal', 
      'error-message user-edit-error',
      $.parseJSON(data.responseText))
    # Render flash
    $("#flash-container").html("<%= j render_flash %>").stop().hide().fadeIn ->
      $(this).delay(3000).fadeOut()
  
  # Clear errors when form is submitted again    
  $(".edit_goal").on "submit", ->
    $(".edit_goal form").clear_form_errors()
    
  # Trigger action when helper clicked
  $('.helper-button').click ->
    $("#"+$(this).data("helper")).click()
    
  # Convert date-time on submit
  $("#improvement_date").on 'change', ->
    time = new Date($('#improvement_date').val())
    # Middle of the day
    time.setHours(12,0,0,0)
    $('#improvement_date_utc').val(time.toUTCString())
    
  # Convert date-time on submit
  $("#goal_due_date").on 'change', ->
    time = new Date($('#goal_due_date').val())
    time.setHours(0,0,0,0)
    $('#goal_due_date_utc').val(time.toUTCString())