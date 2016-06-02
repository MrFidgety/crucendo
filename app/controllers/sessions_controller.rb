class SessionsController < ApplicationController
  
  def new
  end
  
  def edit
    user = User.find_by(email: params[:email])
    if user && user.activated? && user.authenticated?(:login, params[:id])
      # consume login digest
      user.update_attribute(:login_digest, nil)
      log_in user
      flash[:success] = "Account logged in!"
      redirect_to user
    else
      flash[:danger] = "Invalid login link"
      redirect_to root_url
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
