$('#improved-goals').append('<%= j render @improvements %>')
<% if @improvements.next_page %>
$('.pagination').replaceWith('<%= j will_paginate @improvements %>')
<% else %>
$(window).off('scroll')
$('.pagination').remove()
<% end %>