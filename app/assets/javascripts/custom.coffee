$(document).on "page:change page:restore", ->
  
  # fade main content in
  $('#site-content').hide().fadeIn(600)
  
  # focus on signup form when help modal closes
  $('#help-modal').on 'hidden.bs.modal', ->
    $('#user_email').focus()
    
  # Ensure preselected radio buttons are visually clicked
  $('[checked="checked"]').parent().click()

  # set off-canvas navigation menu
  panel = $('#slide-panel').scotchPanel({
    containerSelector: '#site-wrapper',
    direction: 'left',
    duration: 600,
    transition: 'ease',
    clickSelector: '.toggle-panel',
    distanceX: '300px',
    enableEscapeKey: true
    beforePanelOpen: -> 
      $('#fixed-nav').show()
    afterPanelClose: ->
      $('#fixed-nav').hide()
  })
  
  # ensure navigation panel starts closed 
  # (fix issue when back button is pressed after using navigation)
  panel.close()
  
  # click/touch to close menu
  $(document).on('click touchstart', '.scotch-is-showing', (e) ->
    panel.close()
    # prevent safari from registering touch event under overlay
    e.preventDefault() 
  )
  
  # move all modals to end of body (prevent nested z-index issues)
  $('.modal').each ->
    $(this).detach().appendTo('body')
    
  # manage tab persistence
  if location.hash != ''
    $('a[href="'+location.hash+'"]').tab('show')

  $('a[data-toggle="tab"]').on 'shown', (e) ->
    location.hash = $(e.target).attr('href').substr(1)
    
  # AJAX form responses - errors
  $.fn.render_form_errors = (model_name, error_class, errors) ->
    form = this
    this.clear_form_errors()
  
    $.each(errors, (field, messages) ->
      $('#' + model_name + '_' + field).wrap('<div class="has-error"></div>')
      error = $('<small class="'+error_class+'">'+messages[0]+'</small>').hide()
      $('#' + model_name + '_' + field).parent().append(error)
      error.fadeIn(300)
    )
  
  # clear AJAX form errors  
  $.fn.clear_form_errors = () ->
    $('.error-message').unwrap()
    $('.error-message').remove()