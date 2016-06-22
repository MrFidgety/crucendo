class Admin::QuestionsController < AdminController
  before_action :insert_breadcrumbs

  def index
    @questions = Question.paginate(page: params[:page])
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
      redirect_to admin_questions_path
    else
      render 'new'
    end
  end
  
  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(question_params)
      set_flash :successful_update, type: :success, object: @question
      redirect_to admin_questions_path
    else
      render 'edit'
    end
  end
  
  def destroy
    Question.find(params[:id]).destroy
    redirect_to admin_questions_path
  end
  
  private

    def question_params
      params.require(:question).permit(:content, :question_category_id)
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

end
