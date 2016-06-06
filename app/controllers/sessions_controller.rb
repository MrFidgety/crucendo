class SessionsController < ApplicationController
  before_action :logged_in_user,    only: [:edit]
  before_action :get_user,          only: [:edit]
  before_action :valid_user,        only: [:edit]
  before_action :check_expiration,  only: [:edit]
  
  def new
  end
  
  def edit
    # consume login digest
    @user.update_attribute(:login_digest, nil)
    log_in @user
    remember @user
    set_flash :welcome, type: :success
    redirect_to @user
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
  private
  
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? && 
              @user.authenticated?(:login, params[:id]))
        set_flash :link_expired, type: :warning
        redirect_to root_url
      end
    end

    # Checks expiration of reset token.
    def check_expiration
      if @user && @user.login_link_expired?
        set_flash :link_expired, type: :warning
        redirect_to begin_path
      end
    end
    
    # Confirms a logged-in user.
    def logged_in_user
      redirect_to current_user if logged_in?
    end
end
