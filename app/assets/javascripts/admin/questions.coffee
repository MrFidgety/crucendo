jQuery ->
  $('#import-file').change ->
    $('#import-display').val($('#import-file').val().split('\\').pop())