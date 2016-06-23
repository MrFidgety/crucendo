class Admin::Questions::CategoriesController < ApplicationController
  before_action :insert_breadcrumbs
  
  def index
    @categories = QuestionCategory.paginate(page: params[:page])
  end
  
  def new
    @category = QuestionCategory.new
  end
  
  def edit
    @category = QuestionCategory.find(params[:id])
  end
  
  def create
    @category = QuestionCategory.new(category_params)
    if @category.save
      set_flash :successful_create, type: :success, object: @category
      redirect_to admin_questions_categories_path
    else
      render 'new'
    end
  end
  
  def update
    @category = QuestionCategory.find(params[:id])
    if @category.update_attributes(category_params)
      set_flash :generic_successful_update, type: :success
      redirect_to admin_questions_categories_path
    else
      render 'edit'
    end
  end
  
  def destroy
    @category = QuestionCategory.find(params[:id])
    if !@category.questions.empty?
      set_flash :questions_assigned_error, type: :danger, object: @category
      redirect_to admin_questions_categories_path
    else
      QuestionCategory.find(params[:id]).destroy
      set_flash :successful_destroy, type: :success, object: @category
      redirect_to admin_questions_categories_path
    end
  end
  
  private
  
    def category_params
      params.require(:question_category).permit(:name)
    end

    def insert_breadcrumbs
      if action_name == 'index'
        add_breadcrumb "admin", :admin_path
        add_breadcrumb "questions", :admin_questions_path
        add_breadcrumb "categories"
      else
        add_breadcrumb "admin", :admin_path
        add_breadcrumb "questions", :admin_questions_path
        add_breadcrumb "categories", :admin_questions_categories_path
        add_breadcrumb action_name
      end
    end
end
