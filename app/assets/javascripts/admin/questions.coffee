$(document).on "page:change", ->
  # clean file upload interface
  $('#import-file').change ->
    $('#import-display').val($('#import-file').val().split('\\').pop())