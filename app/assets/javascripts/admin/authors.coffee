$(document).on "page:change", -> 
  # clean file upload interface
  $('#author_logo').change ->
    $('#author-logo-display').val($('#author_logo').val().split('\\').pop())