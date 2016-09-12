class Admin::UsersController < AdminController
  before_action :insert_breadcrumbs
  
  def index
    @users = User.created_recent.paginate(page: params[:page])
    
    respond_to do |format|
      format.html
      format.csv { send_data User.all.order(id: :asc).to_csv, 
                  filename: "crucendo-#{Rails.env}-users-#{Time.current}.csv" }
    end
  end
  
  private
  
    def insert_breadcrumbs
      add_breadcrumb "admin", :admin_path
      case action_name
        when 'index'
          add_breadcrumb "users"
        when 'show'
          add_breadcrumb "users", :admin_users_path
          add_breadcrumb @user.name
      end
    end
end
