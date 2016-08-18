$(document).on "page:change", -> 
  $('#topic_picture').change ->
    $('#topic-picture-display').val($('#topic_picture').val().split('\\').pop())