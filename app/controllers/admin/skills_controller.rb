class Admin::SkillsController < AdminController
  before_action :insert_breadcrumbs
  helper_method :sort_column, :sort_direction
  
  def index
    @skills = Skill.filter(params.slice(:global))
                    .search(params[:search])
                    .order(sort_column + ' ' + sort_direction)
                    .paginate(:per_page => 20, :page => params[:page])
  end
  
  def new
    @skill = Skill.new
  end
  
  def edit
    @skill = Skill.find(params[:id])
  end
  
  def create
    @skill = Skill.new(skill_params)
    if @skill.save
      set_flash :successful_create, type: :success, object: @skill
      redirect_to admin_skills_path
    else
      render 'new'
    end
  end
  
  def update
    @skill = Skill.find(params[:id])
    if @skill.update_attributes(skill_params)
      set_flash :generic_successful_update, type: :success
      redirect_to admin_skills_path
    else
      render 'edit'
    end
  end
  
  def destroy
    @skill = Skill.find(params[:id])
    @skill.update_attribute(:global, false)
    set_flash :successful_destroy, type: :success, object: @skill
    redirect_to admin_skills_path
  end
  
  private
  
    def skill_params
      params.require(:skill).permit(:name, :global)
    end
  
    def insert_breadcrumbs
      if action_name == 'index'
        add_breadcrumb "admin", :admin_path
        add_breadcrumb "skills"
      else
        add_breadcrumb "admin", :admin_path
        add_breadcrumb "skills", :admin_skills_path
        add_breadcrumb action_name
      end
    end
    
    def sort_column
      if params[:sort].blank?
        "name"
      else
        params[:sort]
      end
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
    end
end