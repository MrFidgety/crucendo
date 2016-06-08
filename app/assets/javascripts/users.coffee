# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = -> 
  # Set country to autocomplete
  $('#user_country_code').selectToAutocomplete();
  # Ensure preselected radio buttons are visually clicked
  $('[checked="checked"]').parent().click();

$(document).ready(ready)
$(document).on('page:load', ready)
