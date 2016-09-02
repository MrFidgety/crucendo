class Accomplishments::CrucendosController < ApplicationController
  before_action :set_current_user
  before_action :correct_user
  
  def show
  end
  
  private
    def correct_user
      # Ensure crucendo belongs to current user
      redirect_to root_url unless @crucendo = @user.interactions
                                                    .completed
                                                    .find_by(id: params[:id])
    end
end
