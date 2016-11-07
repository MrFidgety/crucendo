$(document).on "page:change page:restore", -> 

  # Convert date-time on submit
  $("#post_published_date").on 'change', ->
    time = new Date($('#post_published_date').val())
    time.setHours(0,0,0,0)
    $('#post_published_date_utc').val(time.toUTCString())