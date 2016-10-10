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
  
  # open new improvement modal
  $('#new_improvement_start').click ->
    $('#new_improvement_modal').modal('show')
    $('#goal_encrypted_goal').val($('#new_improvement_text').val())
    
  # trigger new improvement modal on 'enter'
  $('#new_improvement_text').keypress (e) ->
    if(e.keyCode == 13)
      $('#new_improvement_start').click()
      return false
      
  $('#new_improvement_modal').on 'hide.bs.modal', ->
    $('#new_improvement_text').val('')
  
  # Reset improvement form
  $('#new_improvement_modal').on 'hidden.bs.modal', ->
    $('#goal_encrypted_goal').val('')
    $("#new_goal form").clear_form_errors()
    # Reset 'want to actively improve this' button
    if $('.improve-btn').hasClass('active')
      $('.improve-btn').button('toggle')

  # Pre-emptivley toggle to improved on link click (before ajax)
  $(document).on('click', 'a.goal-have' , ->
    goal = $( this ).parents('.goal-panel')
    goal.toggleClass('improved')
  )

  #------------------ WANT ------------------#
  
  # Open new goal modal
  $('#new_goal_start').click ->
    $('#new_goal_modal').modal('show')
    $('#goal_encrypted_goal').val($('#new_goal_text').val())
    
  # Trigger new goal modal on 'enter'
  $('#new_goal_text').keypress (e) ->
    if(e.keyCode == 13)
      $('#new_goal_start').click()
      return false
      
  # Clear input when modal closes
  $('#new_goal_modal').on 'hide.bs.modal', ->
    $('#new_goal_text').val('')
  
  # Reset goal form
  $('#new_goal_modal').on 'hidden.bs.modal', ->
    $('#goal_encrypted_goal, #goal_due_date').val('')
    $("#new_goal form").clear_form_errors()

  # Render new goal form errors
  $("#new_goal").on "ajax:error", (e, data, status, xhr) ->
    $("#new_goal form").render_form_errors('goal', 
      'error-message goal-error',
      $.parseJSON(data.responseText))
      
  # Render edit goal form errors
  $("#edit_goal_modal").on "ajax:error", ".edit_goal", (e, data, status, xhr) ->
    $(".edit_goal form").render_form_errors('edit_goal', 
      'error-message goal-error',
      $.parseJSON(data.responseText))
    
  # Convert date-time on submit
  $("#goal_due_date").on 'change', ->
    time = new Date($('#goal_due_date').val())
    time.setHours(0,0,0,0)
    $('#goal_due_date_utc').val(time.toUTCString())
    
  #------------------ FEELING ------------------#
  
  # Initialize swiper when document ready
  if $('#swiper-feeling.swiper-container').length
    feeling = $('#swiper-feeling.swiper-container').swiper({
      initialSlide: 2,
      centeredSlides: true,
      mousewheelControl: true,
      slideToClickedSlide: true,
      slidesPerView: 5,
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