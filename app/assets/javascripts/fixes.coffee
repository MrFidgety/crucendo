$(document).on "page:change page:restore", ->
  
  # Fix for modal input on iOS devices
  if( navigator.userAgent.match(/iPhone|iPad|iPod/i) )
    $('.modal').on 'show.bs.modal', () ->
      # Take page scroll to top so when input is focused, no scrolling occurs
      window.scrollTo(0, 0)
      # Position backdrop absolute and make it span the entire page
      # Also dirty, but we need to tap into the backdrop after Boostrap 
      # positions it but before transitions finish.
      setTimeout( () ->
        $('.modal-backdrop').css({
          position: 'absolute', 
          top: 0, 
          left: 0,
          width: '100%',
          height: Math.max(
            document.body.scrollHeight, document.documentElement.scrollHeight,
            document.body.offsetHeight, document.documentElement.offsetHeight,
            document.body.clientHeight, document.documentElement.clientHeight
          ) + 'px'
        });
      , 0)
