class SessionsController < ApplicationController
  before_action :logged_in_user,    only: [:edit]
  before_action :get_user,          only: [:edit]
  before_action :valid_user,        only: [:edit]
  before_action :check_expiration,  only: [:edit]

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
      set_flash :welcome, type: :success

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
    set_flash :welcome, type: :success
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
          # Respond with login sent notice
          respond_to do |format|
            format.html { redirect_to root_url }
            format.js   { @response_form = 'users/login_sent' }
          end
        else
          # Send regular activation email
          @user.send_activation_email
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
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
  private
  
    # Confirms a logged-in user.
    def logged_in_user
      redirect_to root_url if logged_in?
    end
    
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? && 
              @user.authenticated?(:login, params[:id]))
        set_flash :link_error, type: :danger
        redirect_to root_url
      end
    end

    # Checks expiration of reset token.
    def check_expiration
      if @user && @user.login_link_expired?
        set_flash :link_expired, type: :warning
        redirect_to root_url
      end
    end
end