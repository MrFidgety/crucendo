class Admin::QuestionsController < AdminController
  before_action :insert_breadcrumbs
  before_action :check_import_file, only: :import
  helper_method :sort_column, :sort_direction

  def index
    @questions = Question.filter(params.slice(:topic_id, :active))
                    .includes(:topic)
                    .where(archived: false)
                    .search(params[:search])
                    .order(sort_column + ' ' + sort_direction)
                    .paginate(:per_page => 20, :page => params[:page])
  end
  
  def new
    @question = Question.new
  end
  
  def edit
    @question = Question.find(params[:id])
  end
  
  def create
    @question = Question.new(question_params)
    if @question.save
      set_flash :successful_create, type: :success, object: @question
      redirect_to admin_questions_path
    else
      render 'new'
    end
  end
  
  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(question_params)
      set_flash :generic_successful_update, type: :success
      redirect_to admin_questions_path
    else
      render 'edit'
    end
  end
  
  def destroy
    @question = Question.find(params[:id])
    @question.update_attribute(:archived, true)
    set_flash :successful_destroy, type: :success, object: @question
    redirect_to admin_questions_path
  end
  
  def import
    Question.import(params[:file])
    redirect_to admin_questions_path
  end
    
  private

    def question_params
      params.require(:question).permit(:content, :topic_id, :active)
    end
    
    def insert_breadcrumbs
      if action_name == 'index'
        add_breadcrumb "admin", :admin_path
        add_breadcrumb "questions"
      else
        add_breadcrumb "admin", :admin_path
        add_breadcrumb "questions", :admin_questions_path
        add_breadcrumb action_name
      end
    end
    
    def sort_column
      if params[:sort].blank?
        "content"
      else
        params[:sort]
      end
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
    end
    
    def check_import_file
      accepted_formats = [".csv"]
      if params[:file].blank? || !accepted_formats.include?(File.extname(params[:file].original_filename))
        redirect_to admin_questions_path
      end
    end

end
