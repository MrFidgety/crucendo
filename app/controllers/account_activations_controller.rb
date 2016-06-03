class AccountActivationsController < ApplicationController
  before_action :get_user,         only: [:edit]
  before_action :valid_user,       only: [:edit]
  before_action :check_expiration, only: [:edit]
  
  def edit
    @user.activate
    @user.remember
    log_in @user
    flash[:success] = "Account activated!"
    redirect_to @user
  end
  
  private
  
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # Confirms a valid user.
    def valid_user
      unless (@user && !@user.activated? &&
              @user.authenticated?(:activation, params[:id]))
        flash[:danger] = "Invalid activation link"
        redirect_to root_url
      end
    end
  
    def check_expiration
      if @user.activation_link_expired?
        flash[:danger] = "Activation link has expired."
        redirect_to begin_path
      end
    end
end
