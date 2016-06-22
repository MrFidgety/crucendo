class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include FlashHelper
  
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
end
