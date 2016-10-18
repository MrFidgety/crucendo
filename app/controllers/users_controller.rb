class UsersController < ApplicationController
  include InteractionsHelper
  
  before_action :allow_signup,      only: :show
  before_action :set_current_user,  except: [:new, :create]
  before_action :admin_user,        only: :destroy
  
  # Prevent flash from appearing twice after AJAX call
  after_filter { flash.discard if request.xhr? }
  
  def show
    # Get basic dashboard stats
    @goals_completed_count = @user.goals.completed(true).size
    @improvements_count = @user.improvements.this_month.size
    @consecutive_days = @user.interaction_streak_days
    # Add todays interaction if complete
    if @user.interactions.completed.where("updated_at >= ?", 
        Time.zone.now.beginning_of_day).size > 0
      @consecutive_days.blank? ? @consecutive_days = 1 : @consecutive_days += 1
    end
  end
  
  def new_email
    # Validate email via regex
    if params[:email] =~ User::VALID_EMAIL_REGEX
      if User.exists?(:email => params[:email])
        # Alert user if email exists
        set_flash :email_taken, type: :danger
      else
        # Set parameters for new email
        @user.send_change_email_approval(params[:email])
        set_flash :new_email_approval, type: :success, object: @user
      end
    else
      set_flash :invalid_email_format, type: :danger
    end
    redirect_to profile_path
  end
  
  def create
    # Check if user exists
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user
      # Check if user is activated
      if @user.activated?
        # Respond with login form
        respond_to do |format|
          format.html { redirect_to root_url }
          format.js   { @response_form = 'password_login' }
        end
      else
        if @user.activation_link_expired?
          # Resend activation automatically
          @user.send_activation_email
          # Respond with activation sent notice
          respond_to do |format|
            format.html { redirect_to root_url }
            format.js   { @response_form = 'activation_sent' }
          end
        else
          # Respond with resend activation prompt
          respond_to do |format|
            format.html { redirect_to root_url }
            format.js   { @response_form = 'resend_activation_prompt' }
          end
        end
      end
    else
      # Attempt to create new user
      @user = User.new(signup_params)
      if @user.save
        # Send activation email
        @user.send_activation_email
        # Respond with activation sent notice
        respond_to do |format|
          format.html { redirect_to root_url }
          format.js   { @response_form = 'activation_sent' }
        end
      else
        # Display signup errors
        respond_to do |format|
          format.html { render action: 'new' }
          format.js   { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end
  
  def update
    if @user.update_attributes(user_params)
      # Set flash to notify user of success
      set_flash :good_button, type: :success
      respond_to do |format|
        format.html { redirect_to profile_path }
        format.js
      end
    else
      respond_to do |format|
        format.html { render action: 'edit' }
        format.js   { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    redirect_to root_url
  end
  
  private

    # Allowed user parameters
    def user_params
      params.require(:user).permit(:name, :year_of_birth, :gender, 
                                    :country_code, :time_zone,
                                    :password, :password_confirmation)
    end
    
    # Allowed signup parameters
    def signup_params
      params.require(:user).permit( :email )
    end
    
    # Take user to signup if not logged in
    def allow_signup
      unless logged_in?
        @user = User.new
        render 'new'
      end
    end
end
