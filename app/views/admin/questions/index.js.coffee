$('#questions-container').append('<%= j render @questions %>')
<% if @questions.next_page %>
$('.pagination').replaceWith('<%= j will_paginate @questions %>')
<% else %>
$(window).off('scroll')
$('.pagination').remove()
<% end %>