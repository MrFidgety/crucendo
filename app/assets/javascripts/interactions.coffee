$(document).on "page:change", -> 
  
  #---------------- QUESTIONS ---------------#
  
  # prevent 'enter' submitting question answer
  $('#answer_content').keypress (e) ->
    if(e.keyCode == 13)
      return false
      
  #------------------ HAVE ------------------#
  
  # move initial 'improved' goals
  $('.goal_panel.improved').each ->
    $(this).detach().appendTo('#improved_goals')
  
  # open new improvement modal
  $('#new_improvement_start').click ->
    $('#new_improvement_modal').modal('show')
    $('#goal_content').val($('#new_improvement_text').val())
    
  # trigger new improvement modal on 'enter'
  $('#new_improvement_text').keypress (e) ->
    if(e.keyCode == 13)
      $('#new_improvement_start').click()
      return false
      
  # focus on input when modal opens   
  $('#new_improvement_modal').on 'shown.bs.modal', ->
    $('#goal_content').focus()
    
  # clear input when modal closes
  $('#new_improvement_modal').on 'hide.bs.modal', ->
    $('#new_improvement_text').val('')
  
  # reset improvement form and focus on input
  $('#new_improvement_modal').on 'hidden.bs.modal', ->
    $('#goal_content').val('')
    $("#new_goal form").clear_form_errors()
    $('#new_improvement_text').focus()
      
  # ensure all collapsibles are set to toggle false
  $('.collapse').collapse({'toggle': false})
  
  # pre-emptivley toggle to improved on link click (before ajax)
  $(document).on('click', 'a.have_goal' , ->
    goal = $( this ).parents('.panel-group')

    if !goal.hasClass('improved')
      goal.detach().appendTo('#improved_goals')
    else
      goal.detach().appendTo('#all_goals')
    goal.toggleClass('improved')
    $('#new_improvement_text').focus()
  )
  
  # search/filter functionality for improvements
  $('#new_improvement_text').keyup ->
    search_array = $(this).val().toLowerCase().split(/[\s,]+/)
    count = 0
    $('.goal_content').each ->
      # do not hide improved goals
      if $(this).parents('.panel-group').hasClass('improved')
        return true
      match = false
      text = $(this).text().toLowerCase()
      # search goals for each 3+ letter word in the query
      for search_text in search_array
        if search_text.length > 2 && text.indexOf(search_text) != -1
          match = true 
          count++
      # show or hide the goals    
      if match
        $(this).parents('.panel-group').slideDown()
      else
        $(this).parents('.panel-group').slideUp()
    if count == 0
      $('#improvement_help_text').html('awesome, something new!')
    else
      $('#improvement_help_text').html('is it one of these?')
  
  #------------------ WANT ------------------#
  
  # open new goal modal
  $('#new_goal_start').click ->
    $('#new_goal_modal').modal('show')
    $('#goal_content').val($('#new_goal_text').val())
    
  # trigger new goal modal on 'enter'
  $('#new_goal_text').keypress (e) ->
    if(e.keyCode == 13)
      $('#new_goal_start').click()
      return false
      
  # focus on input when modal opens   
  $('#new_goal_modal').on 'shown.bs.modal', ->
    $('#goal_content').focus()
    
  # clear input when modal closes
  $('#new_goal_modal').on 'hide.bs.modal', ->
    $('#new_goal_text').val('')
  
  # reset goal form and focus on input
  $('#new_goal_modal').on 'hidden.bs.modal', ->
    $('#goal_content, #goal_due_date').val('')
    $('#due_date_container').collapse('hide')
    $("#new_goal form").clear_form_errors()
    $('#new_goal_text').focus()

  # render new goal form errors
  $(document).on "ajax:error", "form", (evt, xhr, status, error) ->
    $("#new_goal form").render_form_errors('goal', $.parseJSON(xhr.responseText))
    
  # convert date-time on submit
  $("#new_goal").submit ->
    time = new Date($('#goal_due_date').val())
    time.setHours(0,0,0,0)
    $('#goal_due_date_utc').val(time.toUTCString())
    
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