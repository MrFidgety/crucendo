# Fill contact modal with specific contact form
<% if @type == "business" %>
$("#contact-modal-container").html(
  "<%= j render partial: 'contacts/business_contact' %>")
<% else %>
$("#contact-modal-container").html(
  "<%= j render partial: 'contacts/general_contact' %>")
<% end %>

# Show the contact modal
$('#contact-modal').modal('show')

# Set up error handling
$("#new_contact").on "ajax:error", (e, data, status, xhr) ->
  $("#new_contact form").render_form_errors('contact', 
    'error-message goal-error',
    $.parseJSON(data.responseText))