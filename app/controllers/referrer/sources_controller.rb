require_dependency 'referrer/application_controller'

module Referrer
  class SourcesController < ApplicationController
    def mass_create
      user = Referrer::User.where(id: mass_source_params[:user_id], token: mass_source_params[:user_token]).first
      if user.present?
        sessions = user.sessions
        @sources = JSON.parse(mass_source_params[:values]).inject([]) do |r, pack|
          session ||= sessions.detect{|session| session.id == pack['session_id'].to_i} ||
              sessions.detect{|session| session.id == mass_source_params[:current_session_id].to_i}
          raise "No session for #{pack.inspect} (params: #{mass_source_params})" if session.blank?
          if session.sources.exists?(client_duplicate_id: pack['client_duplicate_id'])
            r
          else
            r << session.sources.create!(entry_point: pack['entry_point'], referrer: pack['referrer'],
                                         client_duplicate_id: pack['client_duplicate_id'])
          end
        end
        render json: {ids: @sources.map(&:id)}
      else
        render json: {errors: ['User token is incorrect']}, status: 401
      end
    end

    private

    def mass_source_params
      params.require(:sources).permit(:user_id, :current_session_id, :user_token, :values)
    end
  end
end
