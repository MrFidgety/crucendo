class Admin::UsersController < AdminController
  
  before_action :insert_breadcrumbs
  before_action :validate_search, only: :index
  
  def index
    @users = User.created_recent.filter(
                        params.slice(:min_date, :max_date, :activated))
                        .paginate(:per_page => 10, :page => params[:page])
    
    respond_to do |format|
      format.html
      format.js
      format.csv { send_data User.created_recent.filter(
                  params.slice(:min_date, :max_date, :activated)).to_csv, 
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
    
    def validate_search
      params[:min_date] = Time.zone.parse(params[:min_date]) if params.has_key?(:min_date)
      params[:max_date] = Time.zone.parse(params[:max_date]) if params.has_key?(:max_date)
      case params[:status]
      when 'activated'
        params[:activated] = '1'
      when 'inactive'
        params[:activated] = '0'
      end
    end
end
