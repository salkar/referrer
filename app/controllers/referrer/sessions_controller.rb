require_dependency 'referrer/application_controller'

module Referrer
  class SessionsController < ApplicationController
    def create
      user = Referrer::User.where(id: session_params[:user_id], token: session_params[:user_token]).first
      if user
        @session = user.sessions.create!
        render json: {id: @session.id, active_until: @session.active_until.to_i}
      else
        render json: {errors: ['User token is incorrect']}, status: 401
      end
    end

    private

    def session_params
      params.require(:session).permit(:user_id, :user_token)
    end
  end
end
