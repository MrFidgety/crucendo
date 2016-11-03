$(document).on "page:change", -> 
  # clean file upload interface
  $('#post_image').change ->
    $('#post-image-display').val($('#post_image').val().split('\\').pop())