$(document).on "page:change page:restore", ->
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next_page a').attr('href')
      console.log(url)
      if url && $(window).scrollTop() > $(document).height() - $(window).height() - 400 
        $('.pagination').html("<div class='loader'></div>")
        return $.getScript(url)
    return $(window).scroll()