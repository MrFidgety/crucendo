# Render any flash set during AJAX call
$("#flash-container").html("<%= j render_flash %>").fadeIn ->
  # Clear previous fade timer
  clearTimeout($.data(this, 'timer'))
  # Set new fade timer
  $.data(this, 'timer', setTimeout(() -> 
    $('#flash-container').fadeOut()
  , 3000))

# replace partial with updated version
old_topic = $('#topic_<%= @topic.id %>')
old_topic.replaceWith(
    "<%= j render partial: 'subscriptions/panel', object: @topic, 
    as: :topic %>")