class Admin::TopicsController < AdminController
  before_action :find_topic, only: [:show, :edit, :update, :destroy]
  before_action :find_author, only: :new
  before_action :insert_breadcrumbs
  
  def index
    @topics = Topic.admin.paginate(page: params[:page])
  end
  
  def new
    @topic = Topic.new
    @topic.author_id = @author.id unless @author.blank?
  end
  
  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      set_flash :successful_create, type: :success, object: @topic
      redirect_to admin_topics_path
    else
      render 'new'
    end
  end
  
  def update
    if @topic.update_attributes(topic_params)
      set_flash :generic_successful_update, type: :success
      redirect_to admin_topic_path(@topic)
    else
      render 'edit'
    end
  end
  
  def destroy
    if !@topic.questions.empty?
      set_flash :questions_assigned_error, type: :danger, object: @topic
      redirect_to admin_topic_path(@topic)
    else
      Topic.find(params[:id]).destroy
      set_flash :successful_destroy, type: :success, object: @topic
      redirect_to admin_topics_path
    end
  end
  
  def activate_questions
    @topic = Topic.find(params[:id])
    @topic.questions.update_all(active: true)
    redirect_to admin_topic_path(@topic)
  end
  
  private
  
    def find_topic
      @topic = Topic.find(params[:id])
    end
    
    def find_author
      @author = Author.find(params[:author_id]) if params.has_key?(:author_id)
    end
  
    def topic_params
      params.require(:topic).permit(:name, :active, 
        :default_subscription, :author_id)
    end
  
    def insert_breadcrumbs
      add_breadcrumb "admin", :admin_path
      case action_name
        when 'index'
          add_breadcrumb "tracks"
        when 'show'
          add_breadcrumb "tracks", :admin_topics_path
          add_breadcrumb @topic.name
        when 'edit', 'update'
          add_breadcrumb "tracks", :admin_topics_path
          add_breadcrumb @topic.name, admin_topic_path(@topic)
          add_breadcrumb "edit"
        when 'new'
          if @author.blank?
            add_breadcrumb "tracks", :admin_topics_path
            add_breadcrumb "new"
          else
            add_breadcrumb "authors", :admin_authors_path
            add_breadcrumb @author.name, admin_author_path(@author)
            add_breadcrumb "new"
          end
      end
    end
end
