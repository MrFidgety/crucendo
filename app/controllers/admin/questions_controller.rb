class Admin::QuestionsController < AdminController
  before_action :insert_breadcrumbs
  helper_method :sort_column, :sort_direction

  def index
    @questions = Question.filter(params.slice(:topic_id))
                    .includes(:category).includes(:topic)
                    .where(archived: false)
                    .search(params[:search])
                    .order(sort_column + ' ' + sort_direction)
                    .paginate(:per_page => 5, :page => params[:page])
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
  
  private

    def question_params
      params.require(:question).permit(:content, :topic_id, :category_id, :active)
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

end
