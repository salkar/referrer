require_dependency "referrer/application_controller"

module Referrer
  class UsersController < ApplicationController
    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to @user, notice: 'User was successfully created.'
      else
        render :new
      end
    end

    private

    def user_params
      params.require(:user).permit(:app_user_id)
    end
  end
end
