class Admin::DashboardController < AdminController
  before_action :insert_breadcrumbs
  
  def index
  end
  
  private
  
    def insert_breadcrumbs
      if action_name == 'index'
         add_breadcrumb "admin"
      end
    end
  
end
