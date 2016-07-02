require 'rails_helper'

RSpec.describe Referrer::SourcesController, type: :controller do
  routes { Referrer::Engine.routes }

  before :each do
    @user = Referrer::User.create!
    @session = @user.sessions.create!
  end

  describe 'create' do
    it 'should be done' do
      expect(@session.sources.count).to eq(0)
      post(:create, source: {session_id: @session.id, user_token: @user.token, referrer: 'http://test.com', entry_point: 'http://dummy.com'})
      expect(@session.sources.count).to eq(1)
      source = @session.sources.last
      result = JSON.parse(response.body)
      expect(result.keys).to eq(%w(id))
      expect(result['id']).to eq(source.id)
      expect(source.kind).to eq('referral')
    end

    it 'should not be done because incorrect token' do
      expect(@session.sources.count).to eq(0)
      post(:create, source: {session_id: @session.id, user_token: 'test', referrer: 'http://test.com', entry_point: 'http://dummy.com'})
      expect(@session.sources.count).to eq(0)
      result = JSON.parse(response.body)
      expect(response.code).to eq('401')
      expect(result).to eq({'errors'=>['User token is incorrect']})
    end
  end
end