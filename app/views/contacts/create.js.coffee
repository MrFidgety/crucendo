# Hide contact modal
$('#contact-modal').modal('hide')

# Clear form input values
$('#new_contact')[0].reset()

# Render flash
$("#flash-container").html("<%= j render_flash %>").stop().hide().fadeIn ->
  $(this).delay(3000).fadeOut()