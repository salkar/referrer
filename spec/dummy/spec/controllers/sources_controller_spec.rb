require 'rails_helper'

RSpec.describe Referrer::SourcesController, type: :controller do
  routes { Referrer::Engine.routes }

  before :each do
    @user = Referrer::User.create!
    @session = @user.sessions.create!
  end

  before :each, with_other_sessions: true do
    @other_session = @user.sessions.create!(created_at: Time.now - 1.month)
    @other_session_1 = @user.sessions.create!(created_at: Time.now - 1.day)
  end

  describe 'mass create' do
    it 'should be done' do
      expect(@session.sources.count).to eq(0)
      post(:mass_create, sources: {current_session_id: @session.id, user_token: @user.token, user_id: @user.id, values: [{
                           referrer: 'http://test.com', entry_point: 'http://dummy.com', client_duplicate_id: 1}].to_json})
      expect(@session.sources.count).to eq(1)
      source = @session.sources.last
      result = JSON.parse(response.body)
      expect(result.keys).to eq(%w(ids))
      expect(result['ids']).to eq([source.id])
      expect(source.kind).to eq('referral')
    end

    it 'should not be done because incorrect token' do
      expect(@session.sources.count).to eq(0)
      post(:mass_create, sources: {current_session_id: @session.id, user_token: 'test', user_id: @user.id, values: [{
                           referrer: 'http://test.com', entry_point: 'http://dummy.com', client_duplicate_id: 1}].to_json})
      expect(@session.sources.count).to eq(0)
      result = JSON.parse(response.body)
      expect(response.code).to eq('401')
      expect(result).to eq({'errors'=>['User token is incorrect']})
    end

    it 'should be done for source with session id', with_other_sessions: true do
      expect(@session.sources.count).to eq(0)
      post(:mass_create, sources: {current_session_id: @session.id,
                                   user_token: @user.token,
                                   user_id: @user.id,
                                   values: [{
                                                referrer: 'http://test.com', entry_point: 'http://dummy.com',
                                                client_duplicate_id: 1, session_id: @other_session.id
                                            }].to_json})
      expect(@other_session.sources.count).to eq(1)
      source = @other_session.sources.last
      expect(source.session_id).to eq(@other_session.id)
    end

    it 'should be done with several source values' do
      expect(@session.sources.count).to eq(0)
      post(:mass_create, sources: {current_session_id: @session.id,
                                   user_token: @user.token,
                                   user_id: @user.id,
                                   values: [{referrer: 'http://test.com', entry_point: 'http://dummy.com', client_duplicate_id: 1},
                                            {referrer: 'http://test2.com', entry_point: 'http://dummy2.com', client_duplicate_id: 2}
                                   ].to_json})
      expect(@session.sources.count).to eq(2)
      referrers = @session.sources.pluck(:referrer)
      %w{http://test2.com http://test.com}.each do |referrer|
        expect(referrers.include?(referrer)).to eq(true)
      end
    end

    describe 'with duplicates' do
      it 'in params should not be done' do
        expect(@session.sources.count).to eq(0)
        post(:mass_create, sources: {current_session_id: @session.id,
                                     user_token: @user.token,
                                     user_id: @user.id,
                                     values: [{referrer: 'http://test.com', entry_point: 'http://dummy.com', client_duplicate_id: 1},
                                              {referrer: 'http://test2.com', entry_point: 'http://dummy2.com', client_duplicate_id: 1}
                                     ].to_json})
        expect(@session.sources.count).to eq(1)
        source = @session.sources.last
        expect(source.referrer).to eq('http://test.com')
      end

      it 'in db should not be done' do
        source = @session.sources.create!(referrer: 'http://test.com', entry_point: 'http://dummy.com', client_duplicate_id: 1)
        post(:mass_create, sources: {current_session_id: @session.id,
                                     user_token: @user.token,
                                     user_id: @user.id,
                                     values: [{
                                                  referrer: 'http://test2.com', entry_point: 'http://dummy2.com',
                                                  client_duplicate_id: 1
                                              }].to_json})
        @session.sources.reload
        expect(@session.sources.count).to eq(1)
        expect(Referrer::Source.count).to eq(1)
        s = @session.sources.last
        expect(s.id).to eq(source.id)
      end
    end
  end
end
