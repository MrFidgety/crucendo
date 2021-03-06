class PostsController < ApplicationController
  before_action :find_post, only: [:show]
  before_action :validate_search, only: :index
  
  # Display blog home page
  def index
    @posts = Post.active(true).most_recent.filter(
                        params.slice(
                          :min_date, 
                          :max_date, 
                          :posts_with_track,
                          :posts_from_author))
                        .includes(:author)
                        .paginate(:per_page => 5, :page => params[:page])
    @tracks = Topic.active(true).order(name: :asc)
    @authors = Author.has_posts
    
    # Meta tags
    prepare_meta_tags(title: "Crucendo Blog",
                      description: "Get closer to who you want to be, and what you want to achieve. Your toolkit for success is the Crucendo Blog.",
                      image: view_context.image_url("crucendo-blog-social.png"))
  end
  
  # Display single blog post
  def show
    prepare_meta_tags(title: @post.title,
                      description: @post.summary,
                      image: @post.image.social.url,
                      type: "article")
                      
    @recent_posts = Post.active(true).most_recent.includes(:author).where('posts.id != ?', @post.id).first(3)
    @related_posts = Post.joins(:topics)
      .where('(topics.id IN (?) OR posts.author_id = ?) AND posts.id != ?', 
      @post.topics.pluck(:id), @post.author_id, @post.id)
      .uniq.first(3)
  end
  
  private
  
    def find_post
      @post = Post.find(params[:id])
      
      # If an old id or a numeric id was used to find the record, then
      # the request path will not match the post_path, and we should do
      # a 301 redirect that uses the current friendly id.
      if request.path != post_path(@post)
        return redirect_to @post, :status => :moved_permanently
      end
    end
    
    def validate_search
      params[:min_date] = Time.zone.parse(params[:min_date]) if params.has_key?(:min_date)
      params[:max_date] = Time.zone.parse(params[:max_date]) if params.has_key?(:max_date)
    end
  
end
