class AccomplishmentsController < ApplicationController
  before_action :set_current_user
  
  def index
    # Get list of users interactions
    @interactions = @user.interactions
      .includes(:goals, :improvements, answers: [{question: :topic}])
      .completed
      .paginate(:per_page => 10, :page => params[:page])
  end
end
