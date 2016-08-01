$(document).on 'page:change', ->
  ga('send', 'pageview', window.location.pathname)