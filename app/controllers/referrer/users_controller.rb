require_dependency 'referrer/application_controller'

module Referrer
  class UsersController < ApplicationController
    def create
      @user = User.create!
      render json: {id: @user.id, token: @user.token}
    end

    private

    def user_params
      params.require(:user).permit
    end
  end
end
