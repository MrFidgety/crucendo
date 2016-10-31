# Fix form attribute not working in IE and Edge
ie_fix = () ->
  # Detect if browser supports this
  sampleElement = $('[form]').get(0)
  isIE11 = !window.ActiveXObject and 'ActiveXObject' of window
  if sampleElement and window.HTMLFormElement and sampleElement.form instanceof HTMLFormElement and !isIE11
    # Browser supports it, no need to fix
    return

  $.fn.appendField = (data) ->
    # For form only
    if !@is('form')
      return
    # Wrap data
    if !$.isArray(data) and data.name and data.value
      data = [ data ]
    $form = this
    # Attach new params
    $.each data, (i, item) ->
      $('<input/>').attr('type', 'hidden').attr('name', item.name).val(item.value).appendTo $form
      return
    $form

  # Find all input fields with form attribute point to jQuery object
  $('form[id]').submit((e) ->
    $form = $(this)
    # Serialize data
    data = $('[form=' + $form.attr('id') + ']').serializeArray()
    # Append data to form
    $form.appendField data
    return
  ).each ->
    form = this
    $form = $(form)
    $fields = $('[form=' + $form.attr('id') + ']')
    $fields.filter('button, input').filter('[type=reset],[type=submit]').click ->
      type = @type.toLowerCase()
      if type == 'reset'
        # Reset form
        form.reset()
        # For elements outside form
        $fields.each(->
          @value = @defaultValue
          @checked = @defaultChecked
          return
        ).filter('select').each ->
          $(this).find('option').each ->
            @selected = @defaultSelected
            return
          return
      else if type.match(/^submit|image$/i)
        $(form).appendField(
          name: @name
          value: @value).submit()
      return
    return
  return


$(document).on "page:change page:restore show.bs.modal", ->
  
  ie_fix()
  
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