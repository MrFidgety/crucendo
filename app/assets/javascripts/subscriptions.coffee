# pre-emptivley toggle to subscribed/unsubscribed on link click (before ajax)
$(document).on 'click', 'a.update-subscription' , (event) ->
  # stop rails from following link again
  $(this).removeAttr('data-remote').removeAttr('href')
  topic = $(this).parents('.subscription-panel')
  
  if topic.hasClass('subscribed') && 
      $('.subscription-panel.subscribed').length < 6
    # show subscription limit modal
    $('#subscription-limit').modal('show')
  else if !topic.hasClass('clicked')
    topic.toggleClass('subscribed')
    topic.addClass('clicked')