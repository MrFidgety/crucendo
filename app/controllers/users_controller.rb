class UsersController < ApplicationController
  before_action :authenticated,   only: :show
  before_action :logged_in_user,  only: [:edit, :update]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy
  
  def show
  end
  
  def new
  end
  
  def new_email
    # validate email via regex
    if params[:email] =~ User::VALID_EMAIL_REGEX
      if User.exists?(:email => params[:email])
        # alert user if email exists
        set_flash :email_taken, type: :danger
      else
        # set parameters for new email
        @user = current_user
        @user.send_change_email_approval(params[:email])
        set_flash :new_email_approval, type: :success, object: @user
      end
    else
      set_flash :invalid_email_format, type: :danger
    end
    redirect_to profile_path
  end
  
  def create
    # check if user exists
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user
      if @user.activated?
        if !@user.login_sent_at || @user.login_link_expired?
          # create login digest and send email
          @user.send_login_email
          set_flash :send_login, type: :success, object: @user
        else
          # prompt for login to be resent
          set_flash :resend_login_prompt, type: :success, object: @user
        end
      else
        if @user.activation_link_expired?
          # resend activation
          @user.resend_activation_email
          set_flash :resend_activation, type: :success, object: @user
        else
          # prompt for activation to be resent
          set_flash :resend_activation_prompt, type: :success, object: @user
        end
      end
      redirect_to root_url
    else
      # attempt to create new user
      @user = User.new(signup_params)
      if @user.save
        # send activation email
        @user.send_activation_email
        set_flash :send_activation, type: :success, object: @user
        redirect_to root_url
      else
        render 'new'
      end
    end
  end
  
  def edit
  end
  
  def update
    @user = current_user
    if @user.update_attributes(user_params)
      set_flash :successful_update, type: :success, object: @user
      redirect_to profile_path
    else
      render 'edit'
    end
  end
  
  def resend
    if !params[:email].blank? 
      @user = User.find_by(email: params[:email].downcase)
      if @user
        if @user.activated?
          @user.send_login_email
          set_flash :resend_login_confirm, type: :success, object: @user
        else
          @user.resend_activation_email
          set_flash :resend_activation_confirm, type: :success, object: @user
        end
      end
    end
    redirect_to root_url
  end
  
  def destroy
    User.find(params[:id]).destroy
    redirect_to root_url
  end
  
  private

    def user_params
      params.require(:user).permit( :name, 
                                    :year_of_birth, 
                                    :gender, 
                                    :country_code)
    end
    
    def signup_params
      params.require(:user).permit( :email )
    end
    
    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        set_flash :link_error, type: :warning
        redirect_to root_url
      end
    end
    
    # Confirms the correct user.
    def correct_user
      @user = User.find(current_user.id)
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    def authenticated
      unless logged_in?
        @user = User.new
        render 'new'
      end
    end
end
