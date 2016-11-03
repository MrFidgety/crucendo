$(document).on "page:change page:restore", ->
  
  # Toggle fixed navigation
  $('#navigation-button').on 'click touchstart', (e) ->
    e.preventDefault()
    $(this).add('#fixed-nav, #site-content').toggleClass('nav-active')
    
  # Click/touch site content to close navigation
  $('#site-content').on 'click touchstart', (e) ->
    if $(this).hasClass('nav-active')
      $('#navigation-button, #fixed-nav, #site-content').removeClass('nav-active')
      # Prevent safari from registering touch event under overlay
      e.preventDefault() 
      
  # Ensure preselected radio buttons are visually clicked
  $('[checked="checked"]').parent().click()
  
  # Prevent touch-scrolling on fixed-nav
  $('#fixed-nav').on 'touchmove',(e) ->
    e.preventDefault()
  
  # Move all modals to end of body (prevent nested z-index issues)
  $('.modal').each ->
    $(this).detach().appendTo('body')
    
  # Manage tab persistence
  if location.hash != ''
    $('a[href="'+location.hash+'"]').tab('show')

  $('a[data-toggle="tab"]').on 'shown', (e) ->
    location.hash = $(e.target).attr('href').substr(1)
    
  # Render errors on failed AJAX
  $.fn.render_form_errors = (model_name, error_class, errors) ->
    form = this
    this.clear_form_errors()
  
    $.each(errors, (field, messages) ->
      $('#' + model_name + '_' + field).wrap('<div class="has-error"></div>')
      error = $('<small class="'+error_class+'">'+messages[0]+'</small>').hide()
      $('#' + model_name + '_' + field).parent().append(error)
      error.fadeIn(300)
    )
  
  # Clear form errors
  $.fn.clear_form_errors = () ->
    $('.error-message').unwrap()
    $('.error-message').remove()
    
  # Testimonal swiper
  testimonials = $('#swiper-testimonials.swiper-container').swiper({
    loop: true,
    effect: 'cube',
    slidesPerView: 1,
    spaceBetween: 30,
    centeredSlides: true,
    speed: 1000,
    autoplay: 10000,
    autoplayDisableOnInteraction: false,
    onlyExternal: true,
    cube: {
      shadow: false,
      slideShadows: false,
    }
  })
  
  # Detect if mobile
  @mobileWeb = /Mobile|iP(hone|od|ad)|Android|BlackBerry|IEMobile|Kindle|NetFront|Silk-Accelerated|(hpw|web)OS|Fennec|Minimo|Opera M(obi|ini)|Blazer|Dolfin|Dolphin|Skyfire|Zune/i.test(navigator.userAgent)

  # Enable bootstrap datepicker if native method unavailable
  if ( $('[type="date"]').prop('type') != 'date' )
    $('[type="date"]').each ->
      $(this).datepicker
        format: "yyyy-mm-dd",
        autoclose: true,
        clearBtn: true,
        todayHighlight: true

  # Trigger calendar input when button pressed
  $('.calendar-helper').click ->
    $(this).parent().next().click().focus()
    
  # Fix ios safari issue with clearing date value
  $('[type="date"]').focus (e) ->
    e.currentTarget.defaultValue = ''
    
  if (!$('#flash-container').is(':empty'))
    $('#flash-container').delay(500).fadeIn ->
      $(this).delay(3000).fadeOut()
  
  # Fade out flash container when clicked
  $('#flash-container').click ->
    $(this).stop().fadeOut()
    
  $('#start-crucendo-button').click ->
    ga('send', 'event', 'Crucendo', $(this).data('type'))
    