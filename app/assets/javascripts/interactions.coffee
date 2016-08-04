$(document).on "page:change", -> 
  
  # open new goal modal
  $('#new_goal_start').click ->
    $('#new_goal_modal').modal('show')
    $('#goal_content').val($('#new_goal_text').val())
    
  # trigger new goal model on 'enter'
  $('#new_goal_text').keypress (e) ->
    if(e.keyCode == 13)
      $('#new_goal_start').click()
      return false
  
  # focus on input when modal opens   
  $('#new_goal_modal').on 'shown.bs.modal', ->
    $('#goal_content').focus()
    
  $('#new_goal_modal').on 'hide.bs.modal', ->
    $('#new_goal_text').val('')
  
  $('#new_goal_modal').on 'hidden.bs.modal', ->
    $('#goal_content, #goal_due_date').val('')
    $('#due_date_container').collapse('hide')
    $("#new_goal form").clear_form_errors()
    $('#new_goal_text').focus()

  $(document).on "ajax:error", "form", (evt, xhr, status, error) ->
    $("#new_goal form").render_form_errors('goal', $.parseJSON(xhr.responseText))
    
  $("#new_goal").submit ->
    time = new Date($('#goal_due_date').val())
    time.setHours(0,0,0,0)
    $('#goal_due_date_utc').val(time.toUTCString())
    
  # ensure all collapsibles are set to toggle false
  $('.collapse').collapse({'toggle': false})
  
  # sortable = Sortable.create($('#sort-me').get(0), {
  #   handle: '.sort-handle',
  #   animation: 150,
  #   chosenClass: 'sort-chosen',
  #   onEnd: (evt) ->
  #     console.log(sortable.toArray())
  # }) if $('#sort-me').length
  
# display form errors for each input
$.fn.render_form_errors = (model_name, errors) ->
  form = this
  this.clear_form_errors()

  $.each(errors, (field, messages) ->
    input = $('input[name="' + model_name + '[' + field + ']"]');
    input.wrap('<div class="error"></div>')
    input.parent().append('<small class="error_message">' + messages.join(' and ') + '</small>')
  )

# clear AJAX form errors  
$.fn.clear_form_errors = () ->
  $('.error :input').unwrap()
  $('.error_message').remove()