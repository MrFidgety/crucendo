class Admin::PostsController < AdminController
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :insert_breadcrumbs
  
  # Show all posts
  def index
    @posts = Post.all.most_recent
  end
  
  # Write new blog post
  def new
    @post = Post.new
  end
  
  # Save new blog post
  def create
    @post = Post.new(post_params)
    if @post.save
      set_flash :successful_create, type: :success, object: @post
      redirect_to admin_posts_path
    else
      render 'new'
    end
  end
  
  # Save existing blog post edit
  def update
    if @post.update_attributes(post_params)
      set_flash :generic_successful_update, type: :success
      redirect_to admin_post_path(@post)
    else
      render 'edit'
    end
  end
  
  def destroy
    @post.destroy
    set_flash :successful_destroy, type: :success, object: @post
    redirect_to admin_posts_path
  end
  
  private
  
    def post_params
      
      if params[:post][:published_date_utc].present?
        params[:post][:published_date] = params[:post][:published_date_utc]
      else
        params[:post][:published_date] = Time.zone.now
      end
      
      params.require(:post).permit(
          :title, 
          :summary, 
          :content, 
          :image, 
          :active, 
          :author_id,
          :published_date,
          topic_ids: [])
    end
    
    def find_post
      @post = Post.find(params[:id])
      
      # If an old id or a numeric id was used to find the record, then
      # the request path will not match the post_path, and we should do
      # a 301 redirect that uses the current friendly id.
      # if request.path != admin_post_path(@post)
      #   return redirect_to admin_post_path(@post), :status => :moved_permanently
      # end
    end
    
    def insert_breadcrumbs
      add_breadcrumb "admin", :admin_path
      case action_name
        when 'index'
          add_breadcrumb "posts"
        when 'show'
          add_breadcrumb "posts", :admin_posts_path
          add_breadcrumb @post.title
        when 'edit', 'update'
          add_breadcrumb "posts", :admin_posts_path
          add_breadcrumb @post.title, admin_post_path(@post)
          add_breadcrumb "edit"
        when 'new'
          add_breadcrumb "posts", :admin_posts_path
          add_breadcrumb "new"
      end
    end
end
