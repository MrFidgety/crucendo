$(document).on "page:change", -> 
  # clean file upload interface
  $('#topic_picture').change ->
    $('#topic-picture-display').val($('#topic_picture').val().split('\\').pop())