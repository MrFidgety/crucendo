class SubscriptionsController < ApplicationController
  before_action :logged_in_user
  
  def index
    @subscriptions = Topic.active(true).order(name: :asc)
  end
  
  def update
    @topic = Topic.find(params[:id])
    if current_user.subscribed?(@topic) 
      current_user.unsubscribe(@topic) unless current_user.subscriptions.size < 6
    else 
      current_user.subscribe(@topic)
    end
  end
end
