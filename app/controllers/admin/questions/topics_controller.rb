class Admin::Questions::TopicsController < ApplicationController
  before_action :insert_breadcrumbs
  
  def index
  end

  def new
  end
  
  def edit
  end
  
  private
  
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
