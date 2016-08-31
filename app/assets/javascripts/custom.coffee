$(document).on "page:change page:restore", ->
  
  # fade main content in
  #$('#site-content').hide().fadeIn('slow');
  
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
      # esure overlay remains full screen
      #$('#site-content').css('position', 'relative')
    afterPanelClose: ->
      $('#fixed-nav').hide()
      #$('#site-content').css('position', 'static')
  })
  
  # ensure starts closed 
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