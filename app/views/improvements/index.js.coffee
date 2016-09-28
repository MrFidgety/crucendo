$('#improvements-container').append('<%= j render @improvements, selectable: true %>')
<% if @improvements.next_page %>
$('.pagination').replaceWith('<%= j will_paginate @improvements %>')
<% else %>
$(window).off('scroll')
$('.pagination').remove()
<% end %>