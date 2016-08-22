$(document).on "page:change page:restore", ->
  
  # set off-canvas navigation menu
  panel = $('#slide-panel').scotchPanel({
    containerSelector: '#site-wrapper',
    direction: 'left',
    duration: 600,
    transition: 'ease',
    clickSelector: '.toggle-panel',
    distanceX: '300px',
    enableEscapeKey: true
  })
  
  # ensure starts closed 
  # (fix issue when back button is pressed after using navigation)
  panel.close()
  
  # click to close menu
  $(document).on('click', '.scotch-is-showing' , ->
    panel.close()
  )
  
  # move all modals to end of body (prevent nested z-index issues)
  $('.modal').each ->
    $(this).detach().appendTo('body')
    
  # manage tab persistence
  if location.hash != ''
    $('a[href="'+location.hash+'"]').tab('show')

  $('a[data-toggle="tab"]').on 'shown', (e) ->
    location.hash = $(e.target).attr('href').substr(1)