$(document).on "page:change", ->
  
  panel = $('#slide-panel').scotchPanel({
    containerSelector: '#site-wrapper',
    direction: 'left',
    duration: 600,
    transition: 'ease',
    clickSelector: '.toggle-panel',
    distanceX: '300px',
    enableEscapeKey: true
  })
  
  $(document).on('click', '.scotch-is-showing' , ->
    panel.close()
  )