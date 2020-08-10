class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".password_reset_instructions"
      redirect_to root_url
    else
      flash.now[:danger] = t ".address_not_found"
      render :new
    end
  end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password, t(".canot_empty")
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update reset_digest: nil
      flash[:success] = t ".password_has_been_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "password_resets.create.address_not_found"
    redirect_to root_url
  end

  def valid_user
    return if @user&.authenticated?(:reset, params[:id]) && @user&.activated?

    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "password_resets.expire"
    redirect_to new_password_reset_url
  end

  def user_params
    params.require(:user).permit User::RESET_PASSWORD_USERS_PARAMS
  end
end
