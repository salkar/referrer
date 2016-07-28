require_dependency 'referrer/application_controller'

module Referrer
  class SessionsController < ApplicationController
    def create
      user = Referrer::User.where(id: session_params[:user_id], token: session_params[:user_token]).first
      if user
        @session = user.sessions.active_at(Time.now).first
        @session = user.sessions.create! unless @session
        render json: {id: @session.id, active_seconds: @session.active_seconds}
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
