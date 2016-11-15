# Render any flash set during AJAX call
$("#flash-container").html("<%= j render_flash %>").hide().fadeIn ->
  $(this).delay(3000).fadeOut()

$('#remember_<%= @remember.id %>').slideUp('slow')