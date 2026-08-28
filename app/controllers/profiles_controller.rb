class ProfilesController < ApplicationController
  before_action :set_user

  def show
    authorize @user, policy_class: ProfilePolicy
  end

  def edit
    authorize @user, policy_class: ProfilePolicy
  end

  def update
    authorize @user, policy_class: ProfilePolicy

    if @user.update(profile_params)
      bypass_sign_in(@user)
      redirect_to profile_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @user, policy_class: ProfilePolicy

    @user.destroy
    redirect_to root_path
  end

  private

  def set_user
    @user = current_user
  end

  def profile_params
    params.require(:user)
          .permit(:first_name, :last_name, :email, :password, :password_confirmation, :photo)
          .reject { |key, value| value.blank? && %w[password password_confirmation].include?(key) }
  end
end
