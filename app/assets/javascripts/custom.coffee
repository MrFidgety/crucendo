$(document).on "page:change", ->
  
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
  
  # click to close menu
  $(document).on('click', '.scotch-is-showing' , ->
    panel.close()
  )
  
  # move all modals to end of body (prevent nested z-index issues)
  $('.modal').each ->
    $(this).detach().appendTo('body')