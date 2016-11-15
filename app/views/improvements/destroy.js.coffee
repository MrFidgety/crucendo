# Render any flash set during AJAX call
$("#flash-container").html("<%= j render_flash %>").hide().fadeIn ->
  $(this).delay(3000).fadeOut()

# Remove the deleted improvement (fade then slide up)
$('#improvement_<%= @improvement.id %>').fadeTo(500, 0.01, () ->
  $(this).slideUp(500)
)