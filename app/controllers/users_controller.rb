class UsersController < ApplicationController
  before_action :new_user,   only: [:new]
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user,   only: [:show, :edit, :update]
  
  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
  end
  
  def new
    @user = User.new
  end
  
  def create
    # check if user exists
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user
      if @user.activated?
        # create login digest and send email
        @user.send_login_email
        flash[:info] = "Thanks for being part of The Crucial Team! 
                        We’ve sent you an email that you can use to login. 
                        See you soon."
        redirect_to root_url
      else
        if @user.activation_link_expired? 
          @user.resend_activation_email
          flash[:info] = "Awesome! It looks like you’re already part of 
                          The Crucial Team. We’ve sent you a link that you can 
                          use to activate your account, it’s okay, we’ll wait 
                          here while you check your email."
        else
          # Prompt for activation email to be resent
          flash[:info] = render_to_string(:partial => "shared/login_failed_message")
        end
        redirect_to root_url
      end
    else
      # attempt to create new user
      @user = User.new(user_params)
      if @user.save
        @user.send_activation_email
        flash[:info] = "You’re one step away from being part of The 
                        Crucial Team. Check out the email we just sent you, 
                        it’s okay, we’ll wait here."
        redirect_to root_url
      else
        render 'new'
      end
    end
  end
  
  def resend
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user && !@user.activated?
      @user.resend_activation_email
      flash[:info] = "Thanks for being part of The Crucial Team! 
                      We’ve sent you an email that you can use to login. 
                      See you soon."
      redirect_to root_url
    end
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email)
    end
    
    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to begin_path
      end
    end
    
    # Confirms user not logged in.
    def new_user
      unless !logged_in?
        redirect_to current_user
      end
    end
    
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end
end
