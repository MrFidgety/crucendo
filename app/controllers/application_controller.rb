class ApplicationController < ActionController::Base
  
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception
  
  include SessionsHelper
  include FlashHelper
  
  before_filter :set_user_time_zone
  
  # Prevent flash from appearing twice after AJAX call
  after_filter { flash.discard if request.xhr? }
  
  def set_flash(result, type: 'info', object: nil, controller: controller_path)
    if object
      flash[:from] = action_name
      flash[:result] = result
      flash[:type] = type
      flash[:object_type] = object.class.name
      flash[:object_id] = object.id
      flash[:controller] = controller
    else
      flash[:from] = nil
      flash[:result] = result
      flash[:type] = type
      flash[:controller] = :shared
    end
  end
  
  def set_user_time_zone
    if current_user.blank? || current_user.time_zone.blank?
      Time.zone = 'UTC'
    else
      Time.zone =  current_user.time_zone
    end
  end
  
  private
  
    # Confirms an admin user
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
  
    # Confirms a logged-in user
    def logged_in_user
      unless logged_in?
        set_flash :link_error, type: :warning
        redirect_to root_url
      end
    end
    
    # Set current user
    def set_current_user
      redirect_to root_url unless @user = current_user
    end
end
