class SessionsController < ApplicationController
  before_action :already_logged_in,    only: [:edit]
  before_action :get_user,          only: [:edit]
  before_action :valid_user,        only: [:edit]
  before_action :check_expiration,  only: [:edit]
  
  # Prevent flash from appearing twice after AJAX call
  # logged_in check required for successful password log in
  after_filter :discard_flash, except: [:create]

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.has_password? && @user.authenticate(params[:session][:password])
      # Log in and remember
      log_in @user
      remember @user
      # Set most recent "remember" browser details
      @user.remembers.order(:updated_at).last.update_attributes(
                                          browser: browser.name,
                                          device: browser.device.name,
                                          platform: browser.platform.name)
      # Welcome user on returning login
      set_flash :login_from_password, type: :success, object: @user
      # Take user to dashboard
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js   { render js: "window.location = '#{root_path}'" }
      end
    else
      @user = User.new
      @user.errors.add(:password, :invalid, message: "nup, that's not it")
      # Display login errors
      respond_to do |format|
        format.html { render action: 'new' }
        format.js   { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    # Consume login digest
    @user.update_attributes(login_digest: nil,
                            login_sent_at: nil)
    # Log in and remember
    log_in @user
    remember @user
    # Set most recent "remember" browser details
    @user.remembers.order(:updated_at).last.update_attributes(
                                          browser: browser.name,
                                          device: browser.device.name,
                                          platform: browser.platform.name)
    # Welcome user on returning login
    set_flash :login_from_email, type: :success, object: @user
    redirect_to root_url
  end
  
  def send_email
    # Ensure email parameter is set
    if !params[:session][:email].blank? 
      @user = User.find_by(email: params[:session][:email].downcase)
      if @user
        if @user.activated?
          # Send regular log in email
          @user.send_login_email
          # Set flash helper
          set_flash :login_check_email, type: :success, object: @user
          # Respond with login sent notice
          respond_to do |format|
            format.html { redirect_to root_url }
            format.js   { @response_form = 'users/login_sent' }
          end
        else
          # Send regular activation email
          @user.send_activation_email
          # Set flash helper
          set_flash :activate_check_email, type: :success, object: @user
          # Respond with activation sent notice
          respond_to do |format|
            format.html { redirect_to root_url }
            format.js   { @response_form = 'users/activation_sent' }
          end
        end
      end
    end
  end
  
  def remove
    @remember = Remember.find(params[:id])
    @remember.destroy if @remember.user == current_user
    # Alert user session was removed
    set_flash :remove_success, type: :success, object: @remember
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
  private
    def discard_flash
      flash.discard if request.xhr? 
    end
    
    # Checks if already logged-in.
    def already_logged_in
      if logged_in?
        set_flash :already_logged_in, type: :warning
        redirect_to root_url 
      end
    end
    
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? && 
              @user.authenticated?(:login, params[:id]))
        # Set generic link invalid error
        set_flash :link_invalid_error, type: :warning
        redirect_to root_url
      end
    end

    # Checks expiration of reset token.
    def check_expiration
      if @user && @user.login_link_expired?
        # Set generic link expired error
        set_flash :link_expired_error, type: :warning
        redirect_to root_url
      end
    end
end