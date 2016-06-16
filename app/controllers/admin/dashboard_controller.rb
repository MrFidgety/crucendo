class Admin::DashboardController < ApplicationController
  before_action :admin_user
  
  def index
  end
  
  private
  
    def admin_user
      unless logged_in? && current_user.admin?
        redirect_to root_url
      end
    end
end
