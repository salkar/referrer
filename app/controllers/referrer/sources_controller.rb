require_dependency 'referrer/application_controller'

module Referrer
  class SourcesController < ApplicationController
    def create
      session = Referrer::Session.find(source_params[:session_id])
      if session.user.token == source_params[:user_token]
        @source = session.sources.create!(entry_point: source_params[:entry_point], referrer: source_params[:referrer])
        render json: {id: @source.id}
      else
        render json: {errors: ['User token is incorrect']}, status: 401
      end
    end

    private

    def source_params
      params.require(:source).permit(:session_id, :user_token, :referrer, :entry_point)
    end
  end
end
