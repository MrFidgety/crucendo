$(document).on "page:change", -> 
  
  # Follow link click when progress 'circle' is clicked
  $('ul.progressbar > li').on 'click', () ->
    href = $(this).find('a:first').attr('href')
    window.location.href = href
  
  #---------------- QUESTIONS ---------------#
  
  # Function to auto grow text areas  
  auto_grow = (x) -> 
    x.css('height', '5px')
    x.css('height', (x.prop("scrollHeight"))+"px")
    
  # Ensure any prefilled text areas are the correct size
  $('textarea.autogrow').each () ->
    auto_grow($(this))
  
  # Resize text area on input
  $('textarea.autogrow').on 'input', () ->
    auto_grow($(this))
  
  #------------------ HAVE ------------------#
  
  # move initial 'improved' goals
  # $('.goal-panel.improved').each ->
  #   $(this).detach().appendTo('#improved-goals')
  
  # open new improvement modal
  $('#new_improvement_start').click ->
    $('#new_improvement_modal').modal('show')
    $('#goal_encrypted_goal').val($('#new_improvement_text').val())
    
  # trigger new improvement modal on 'enter'
  $('#new_improvement_text').keypress (e) ->
    if(e.keyCode == 13)
      $('#new_improvement_start').click()
      return false
      
  # clear input when modal closes
  $('#select-goals-modal').on 'hide.bs.modal', ->
    $('#new_improvement_text').keyup()
    
  $('#new_improvement_modal').on 'hide.bs.modal', ->
    $('#new_improvement_text').val('')
    $('#new_improvement_text').keyup()
  
  # reset improvement form
  $('#new_improvement_modal').on 'hidden.bs.modal', ->
    $('#goal_encrypted_goal').val('')
    # reset 'want to actively improve this' button
    if $('.improve-btn').hasClass('active')
      $('.improve-btn').button('toggle')
    $("#new_goal form").clear_form_errors()
      
  # ensure all collapsibles are set to toggle false
  $('.collapse').collapse({'toggle': false})
  
  # pre-emptivley toggle to improved on link click (before ajax)
  $(document).on('click', 'a.goal-have' , ->
    goal = $( this ).parents('.goal-panel')
    goal.toggleClass('improved')
    
    # if !goal.hasClass('improved')
    #   goal.detach().prependTo('#improved-goals')
    #   $('#select-goals-modal').modal('hide')
    #   goal.addClass('improved')
    #   $('#new_improvement_text').val('')
    #   $('#new_improvement_text').keyup()
    # else
    #   goal.detach().appendTo('#all-goals')
    #   goal.removeClass('improved')
    #   $('#new_improvement_text').keyup()
  )
  
  # search/filter functionality for improvements
  # $('#new_improvement_text').keyup ->
    
  #   # array to hold each search term
  #   search_terms = []
    
  #   # show all goals if there is no search term
  #   if !$(this).val().trim()
  #     $('#all-goals > .goal-panel').each ->
  #       $(this).show()
  #     count = $('#all-goals > .goal-panel').length
  #   else
  #     # split the search term on spaces
  #     search_array = $(this).val().toLowerCase().split(/[\s,]+/)
  #     count = 0
      
  #     # select all strings greater than 2 characters
  #     for search_text in search_array
  #       if search_text.length > 2 
  #         search_terms.push(search_text)
          
  #     $('#all-goals .goal_encrypted_goal').each ->
  #       match = false
  #       text = $(this).text().toLowerCase()
  #       # search goals for each term
  #       for search_text in search_terms
  #         if text.indexOf(search_text) != -1
  #           match = true 
  #           count++
  #       # show or hide the goals    
  #       if match
  #         $(this).parents('.goal-panel').show()
  #       else
  #         $(this).parents('.goal-panel').hide()
  #   if count == 0
  #     $('#select-goals-button>.button-title').html('Awesome, something new!')
  #     $('#select-goals-button>.button-helper>.button-result').html('Hit the Add+ button to add your improvement')
  #     $('#select-goals-button>.button-helper>.button-search-terms').html('')
  #     $('#select-goals-button').prop("disabled", true)
  #   else
  #     $('#select-goals-button>.button-title').html('Select from your active <strong>wants</strong>')
  #     $('#select-goals-button>.button-helper>.button-result').html(count + ' found')
  #     if search_terms.length
  #       $('#select-goals-button>.button-helper>.button-search-terms').html(' from searching ' + '"' + search_terms.join('", "') + '"')
  #     else
  #       $('#select-goals-button>.button-helper>.button-search-terms').html(' in total')
  #     $('#select-goals-button').prop("disabled", false)
  
  # # emulate keyup on page load
  # $('#new_improvement_text').keyup()
  
  #------------------ WANT ------------------#
  
  # open new goal modal
  $('#new_goal_start').click ->
    $('#new_goal_modal').modal('show')
    $('#goal_encrypted_goal').val($('#new_goal_text').val())
    
  # trigger new goal modal on 'enter'
  $('#new_goal_text').keypress (e) ->
    if(e.keyCode == 13)
      $('#new_goal_start').click()
      return false
      
  # clear input when modal closes
  $('#new_goal_modal').on 'hide.bs.modal', ->
    $('#new_goal_text').val('')
  
  # reset goal form
  $('#new_goal_modal').on 'hidden.bs.modal', ->
    $('#goal_encrypted_goal, #goal_due_date').val('')
    $('#due_date_container').collapse('hide')
    $("#new_goal form").clear_form_errors()

  # render new goal form errors
  $("#new_goal").on "ajax:error", (e, data, status, xhr) ->
    $("#new_goal form").render_form_errors('goal', 
      'error-message goal-error',
      $.parseJSON(data.responseText))
                                              
  # convert date-time on submit
  $("#goal_due_date").on 'change', ->
    time = new Date($('#goal_due_date').val())
    time.setHours(0,0,0,0)
    $('#goal_due_date_utc').val(time.toUTCString())
    
  $('#due_date_container').on 'shown.bs.collapse', ->
    $('#goal_due_date').focus()
    
  # sortable = Sortable.create($('#sort-me').get(0), {
  #   handle: '.sort-handle',
  #   animation: 150,
  #   chosenClass: 'sort-chosen',
  #   onEnd: (evt) ->
  #     console.log(sortable.toArray())
  # }) if $('#sort-me').length
  
  #------------------ FEELING ------------------#
  # initialize swiper when document ready
  if $('#swiper-feeling.swiper-container').length
    feeling = $('#swiper-feeling.swiper-container').swiper({
      #pagination: '.swiper-pagination',
      initialSlide: 2,
      centeredSlides: true,
      #paginationClickable: true,
      mousewheelControl: true,
      slideToClickedSlide: true,
      slidesPerView: 5,
      #spaceBetween: 10,
      breakpoints: {
        1024: {
          slidesPerView: 4,
        },
        768: {
          slidesPerView: 3,
        },
        640: {
          slidesPerView: 2,
        },
        320: {
          slidesPerView: 1,
        }
      },
      onInit: (feeling) ->
        $('#interaction_feeling').val(feeling.activeIndex+1)
      onSlideChangeEnd: (feeling) ->
        $('#interaction_feeling').val(feeling.activeIndex+1)
    })
  
# # display form errors for each input
# $.fn.render_form_errors = (model_name, errors) ->
#   form = this
#   this.clear_form_errors()

#   $.each(errors, (field, messages) ->
#     input = $('input[name="' + model_name + '[' + field + ']"]');
#     input.wrap('<div class="error"></div>')
#     input.parent().append('<small class="error_message">' + messages.join(' and ') + '</small>')
#   )

# # clear AJAX form errors  
# $.fn.clear_form_errors = () ->
#   $('.error :input').unwrap()
#   $('.error_message').remove()