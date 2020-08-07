class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user &.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        remember_user user
        flash[:success] = t ".success_login"
        redirect_back_or user
      else
        message = t ".account_not_activated"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash[:danger] = t ".error_login"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def remember_user user
    params[:session][:remember_me] == Settings.remember_user ? remember(user) : forget(user)
  end
end
