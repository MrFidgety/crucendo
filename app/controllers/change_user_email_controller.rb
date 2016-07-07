class ChangeUserEmailController < ApplicationController
  before_action :get_user,          only: [:edit]
  before_action :valid_user,        only: [:edit]
  before_action :correct_user,      only: [:edit]
  before_action :check_expiration,  only: [:edit]
  before_action :email_exists,      only: [:edit]
  
  def edit
    if @user.new_email_approved
      # update email address and clear values
      @user.change_email
      set_flash :confirm_change_activation, type: :success, object: @user
    else
      # send change email activation
      @user.send_change_email_activation
      set_flash :confirm_change_approval, type: :success, object: @user
    end
    redirect_to root_url
  end
  
  private
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # Confirms a valid user.
    def valid_user
      unless (@user && @user.activated? && 
              @user.authenticated?(:new_email, params[:id]))
        set_flash :link_error, type: :danger
        redirect_to root_url
      end
    end
    
    # Checks expiration of new_email token.
    def check_expiration
      if @user && @user.change_email_expired?
        set_flash :link_expired, type: :warning
        redirect_to root_url
      end
    end
    
    # Confirms the correct user.
    def correct_user
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def email_exists
      if User.exists?(:email => @user.new_email)
        set_flash :email_taken, type: :warning
        @user.clear_new_email
        redirect_to root_url
      end
    end
end
