class Admin::QuestionsController < AdminController
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :find_topic, only: :new
  before_action :insert_breadcrumbs
  before_action :check_import_file, only: :import
  helper_method :sort_column, :sort_direction

  def index
    @questions = Question.filter(params.slice(:topic_id, :active))
                    .includes(:topic)
                    .search(params[:search])
                    .order(sort_column + ' ' + sort_direction)
                    .paginate(:per_page => 20, :page => params[:page])
  end
  
  def show
  end
  
  def new
    @question = Question.new
    @question.topic_id = @topic.id unless @topic.blank?
  end
  
  def edit
  end
  
  def create
    @question = Question.new(question_params)
    if @question.save
      set_flash :successful_create, type: :success, object: @question
      redirect_to admin_question_path(@question)
    else
      render 'new'
    end
  end
  
  def update
    if @question.update_attributes(question_params)
      set_flash :generic_successful_update, type: :success
      redirect_to admin_question_path(@question)
    else
      render 'edit'
    end
  end
  
  def destroy
    @question.update(:archived => true, :active => false)
    set_flash :successful_destroy, type: :success, object: @question
    redirect_to admin_topic_path(@question.topic)
  end
  
  def import
    Question.import(params[:file])
    redirect_to admin_questions_path
  end
    
  private

    def find_question
      @question = Question.find(params[:id])
    end
    
    def find_topic
      @topic = Topic.find(params[:topic_id]) if params.has_key?(:topic_id)
    end
    
    def question_params
      params.require(:question).permit(:content, :topic_id, :active)
    end
    
    def insert_breadcrumbs
      add_breadcrumb "admin", :admin_path
      case action_name
        when 'index'
          add_breadcrumb "questions"
        when 'show'
          add_breadcrumb "topics", :admin_topics_path
          add_breadcrumb @question.topic.name, admin_topic_path(@question.topic)
          add_breadcrumb "Q#{@question.id}"
        when 'edit', 'update'
          add_breadcrumb "topics", :admin_topics_path
          add_breadcrumb @question.topic.name, admin_topic_path(@question.topic)
          add_breadcrumb "Q#{@question.id}", admin_question_path(@question)
          add_breadcrumb "edit"
        when 'new'
          if @topic.blank?
            add_breadcrumb "questions", :admin_questions_path
            add_breadcrumb "new"
          else
            add_breadcrumb "topics", :admin_topics_path
            add_breadcrumb @topic.name, admin_topic_path(@topic)
            add_breadcrumb "new"
          end
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
