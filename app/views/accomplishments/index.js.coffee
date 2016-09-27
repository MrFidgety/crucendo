$('#completed-interactions').append('<%= j render @interactions %>')
<% if @interactions.next_page %>
$('.pagination').replaceWith('<%= j will_paginate @interactions %>')
<% else %>
$(window).off('scroll')
$('.pagination').remove()
<% end %>