class SessionsController < ApplicationController
  before_action :get_user,         only: [:edit]
  before_action :valid_user,       only: [:edit]
  before_action :check_expiration, only: [:edit]
  
  def new
  end
  
  def edit
    # consume login digest
    @user.update_attribute(:login_digest, nil)
    log_in @user
    remember @user
    flash[:success] = "Account logged in!"
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
        flash[:danger] = "Invalid login link"
        redirect_to root_url
      end
    end

    # Checks expiration of reset token.
    def check_expiration
      if @user && @user.login_link_expired?
        flash[:danger] = "Login link has expired."
        redirect_to begin_path
      end
    end
end
