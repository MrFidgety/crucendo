class ContactsController < ApplicationController
  
  # Prevent flash from appearing twice after AJAX call
  after_filter { flash.discard if request.xhr? }
  
  def new
    @contact = Contact.new
    respond_to do |format|
      format.js   { @type = params[:type]  if params.has_key?(:type) }
    end
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request

    # Respond to AJAX call
    respond_to do |format|
      if @contact.deliver
        # Set flash to notify user of email
        set_flash :contact_email_sent, type: :success
        format.html { redirect_to root_url }
        format.js
      else
        format.html { render action: 'index' }
        format.js   { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end
  
end