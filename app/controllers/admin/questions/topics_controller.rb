class Admin::Questions::TopicsController < ApplicationController
  before_action :insert_breadcrumbs
  
  def index
    @topics = Topic.paginate(page: params[:page])
  end

  def new
    @topic = Topic.new
  end
  
  def show
    @topic = Topic.find(params[:id])
    @questions = Question.includes(:category).includes(:topic)
                    .where(archived: false, topic_id: @topic.id)
                    .paginate(:per_page => 10, :page => params[:page])
  end
  
  def edit
    @topic = Topic.find(params[:id])
  end
  
  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      set_flash :successful_create, type: :success, object: @topic
      redirect_to admin_questions_topics_path
    else
      render 'new'
    end
  end
  
  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(topic_params)
      set_flash :generic_successful_update, type: :success
      redirect_to admin_questions_topics_path
    else
      render 'edit'
    end
  end
  
  def destroy
    @topic = Topic.find(params[:id])
    if !@topic.questions.empty?
      set_flash :questions_assigned_error, type: :danger, object: @topic
      redirect_to admin_questions_topics_path
    else
      Topic.find(params[:id]).destroy
      set_flash :successful_destroy, type: :success, object: @topic
      redirect_to admin_questions_topics_path
    end
  end
  
  private
  
    def topic_params
      params.require(:topic).permit(:name)
    end
  
    def insert_breadcrumbs
      if action_name == 'index'
        add_breadcrumb "admin", :admin_path
        add_breadcrumb "questions", :admin_questions_path
        add_breadcrumb "topics"
      else
        add_breadcrumb "admin", :admin_path
        add_breadcrumb "questions", :admin_questions_path
        add_breadcrumb "topics", :admin_questions_topics_path
        add_breadcrumb action_name
      end
    end
end
