class SubscriptionsController < ApplicationController
  before_action :logged_in_user
  
  # Prevent flash from appearing twice after AJAX call
  after_filter { flash.discard if request.xhr? }
  
  def index
    @subscriptions = Topic.active(true).order(name: :asc)
  end
  
  def update
    @topic = Topic.find(params[:id])
    if current_user.subscribed?(@topic) 
      unless current_user.subscriptions.size < 6
        current_user.unsubscribe(@topic)
        # Successfully unsubscribed
        set_flash :unsubscribed, type: :success, object: @topic
      end
    else 
      current_user.subscribe(@topic)
      # Successfully subscribed
      set_flash :subscribed, type: :success, object: @topic
    end
  end
end
