class AccountActivationsController < ApplicationController
  before_action :already_logged_in,    only: [:edit]
  before_action :get_user,          only: [:edit]
  before_action :valid_user,        only: [:edit]
  before_action :check_expiration,  only: [:edit]
  
  def edit
    # Activate and log in
    @user.activate
    log_in @user 
    remember @user
    # Set most recent session browser details
    @user.remembers.order(:updated_at).last.update_attributes(
                                              browser: browser.name,
                                              device: browser.device.name,
                                              platform: browser.platform.name)
    # Welcome user on first login
    set_flash :activate_from_email, type: :success, object: @user
    redirect_to root_url
  end
  
  private
  
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # Confirms a valid user.
    def valid_user
      unless (@user && !@user.activated? &&
              @user.authenticated?(:activation, params[:id]))
        # Set generic link invalid error
        set_flash :link_invalid_error, type: :warning
        redirect_to root_url
      end
    end
  
    # Checks activation link is still valid
    def check_expiration
      if @user.activation_link_expired?
        # Set generic link expired error
        set_flash :link_expired_error, type: :warning
        redirect_to root_url
      end
    end
    
    # Checks if already logged-in.
    def already_logged_in
      if logged_in?
        set_flash :already_logged_in, type: :warning
        redirect_to root_url 
      end
    end
end
