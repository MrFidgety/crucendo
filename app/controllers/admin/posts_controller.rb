class Admin::PostsController < AdminController
  before_action :insert_breadcrumbs
  
  # Show all posts
  def index
    @posts = Post.all
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
  
  # Edit blog post
  def edit
  end
  
  # Save existing blog post edit
  def update
  end
  
  private
  
    def post_params
      params.require(:post).permit(:title, :summary, :content, :image)
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
          add_breadcrumb @post.name, admin_post_path(@post)
          add_breadcrumb "edit"
        when 'new'
          add_breadcrumb "posts", :admin_posts_path
          add_breadcrumb "new"
      end
    end
end
