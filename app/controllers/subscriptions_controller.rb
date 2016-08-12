class SubscriptionsController < ApplicationController
  before_action :logged_in_user
  
  def index
    @subscriptions = Topic.active
  end
  
end
