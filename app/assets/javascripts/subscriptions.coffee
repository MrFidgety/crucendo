# pre-emptivley toggle to subscribed/unsubscribed on link click (before ajax)
  $(document).on('click', 'a.update-subscription' , (event) ->
    # stop rails from following link again
    $(this).removeAttr('data-remote').removeAttr('href')
    topic = $(this).parents('.subscription-panel')
    
    if topic.hasClass('subscribed') && 
        $('.subscription-panel.subscribed').length < 8
      # show subscription limit modal
      $('#subscription-limit').modal('show');
      console.log('must have at least 7 subscription')
    else if !topic.hasClass('clicked')
      topic.toggleClass('subscribed')
      topic.addClass('clicked')
  )