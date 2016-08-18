# replace partial with updated version
old_topic = $('#topic_<%= @topic.id %>')
old_topic.replaceWith(
    "<%= j render partial: 'subscriptions/panel', object: @topic, 
    as: :topic %>")