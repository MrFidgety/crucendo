$(document).on "page:change", -> 
  # Set country to autocomplete
  # $('#user_country_code').selectToAutocomplete();
  # Ensure preselected radio buttons are visually clicked
  $('[checked="checked"]').parent().click();
