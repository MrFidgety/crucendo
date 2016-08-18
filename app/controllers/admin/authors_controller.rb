class Admin::AuthorsController < AdminController
  before_action :find_author, only: [:show, :edit, :update, :destroy]
  before_action :insert_breadcrumbs
  
  def index
    @authors = Author.all.paginate(page: params[:page])
  end
  
  def new
    @author = Author.new
  end
  
  def create
    @author = Author.new(author_params)
    if @author.save
      set_flash :successful_create, type: :success, object: @author
      redirect_to admin_authors_path
    else
      render 'new'
    end
  end
  
  def update
    if @author.update_attributes(author_params)
      set_flash :generic_successful_update, type: :success
      redirect_to admin_author_path(@author)
    else
      render 'edit'
    end
  end
  
  def destroy
    if !@author.topics.empty?
      set_flash :topics_assigned_error, type: :danger, object: @author
      redirect_to admin_author_path(@author)
    else
      Author.find(params[:id]).destroy
      set_flash :successful_destroy, type: :success, object: @author
      redirect_to admin_authors_path
    end
  end
  
  private
  
    def author_params
      params.require(:author).permit(:name, :logo, :link, :about)
    end
    
    def find_author
      @author = Author.find(params[:id])
    end
  
    def insert_breadcrumbs
      add_breadcrumb "admin", :admin_path
      case action_name
        when 'index'
          add_breadcrumb "authors"
        when 'show'
          add_breadcrumb "authors", :admin_authors_path
          add_breadcrumb @author.name
        when 'edit', 'update'
          add_breadcrumb "authors", :admin_authors_path
          add_breadcrumb @author.name, admin_author_path(@author)
          add_breadcrumb "edit"
        when 'new'
          add_breadcrumb "authors", :admin_authors_path
          add_breadcrumb "new"
      end
    end
end
