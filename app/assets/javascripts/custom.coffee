$(document).on "page:change page:restore", ->
  
  # Toggle fixed navigation
  $('#navigation-button').click ->
    $(this).add('#fixed-nav, #site-content').toggleClass('nav-active')
    
  # Ensure preselected radio buttons are visually clicked
  $('[checked="checked"]').parent().click()

  # Click/touch site content to close navigation
  $('#site-content').on 'click touchstart', (e) ->
    if $(this).hasClass('nav-active')
      $('#navigation-button, #fixed-nav, #site-content').removeClass('nav-active')
      # Prevent safari from registering touch event under overlay
      e.preventDefault() 
  
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