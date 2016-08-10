class SubscriptionsController < ApplicationController
  before_action :logged_in_user
  
  def index
    #@subscriptions = current_user.subscriptions
    @topics = Topic.active
  end
  
end
