$(document).on "page:change page:restore", ->
  
  $('.search-form').submit ->
    $(this).find(':input').filter(->
      !@value
    ).prop 'disabled', true
    true

  # If they hit back
  $('.search-form').find(':input').prop 'disabled', false

  # If they stop page load and click on the form again it enables
  $('.search-form').on 'click', ->
    $(this).find(':input').prop 'disabled', false

  return