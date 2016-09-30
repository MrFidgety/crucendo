# Render flash
$("#flash-container").html("<%= j render_flash %>").stop().hide().fadeIn ->
  $(this).delay(3000).fadeOut()