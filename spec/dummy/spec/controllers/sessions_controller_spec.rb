require 'rails_helper'
include ControllersCompatibility

RSpec.describe Referrer::SessionsController, type: :controller do
  routes { Referrer::Engine.routes }

  before :each do
    @user = Referrer::User.create!
  end

  describe 'create' do
    it 'should be done' do
      expect(@user.sessions.count).to eq(0)
      post(:create, params(session: {user_id: @user.id, user_token: @user.token}))
      expect(@user.sessions.count).to eq(1)
      session = @user.sessions.last
      result = JSON.parse(response.body)
      expect(result.keys).to eq(%w(id active_seconds))
      expect(result['id']).to eq(session.id)
      expect(result['active_seconds']).to be_within(1).of(session.active_seconds)
    end

    it 'should be done with already active session' do
      session = @user.sessions.create!(active_from: 1.day.ago, active_until: 2.days.since)
      expect(@user.sessions.count).to eq(1)
      post(:create, params(session: {user_id: @user.id, user_token: @user.token}))
      expect(@user.sessions.count).to eq(1)
      result = JSON.parse(response.body)
      expect(result['id']).to eq(session.id)
    end

    it 'should not be done because incorrect token' do
      expect(@user.sessions.count).to eq(0)
      post(:create, params(session: {user_id: @user.id, user_token: 'test'}))
      expect(@user.sessions.count).to eq(0)
      result = JSON.parse(response.body)
      expect(response.code).to eq('401')
      expect(result).to eq({'errors'=>['User token is incorrect']})
    end
  end
end