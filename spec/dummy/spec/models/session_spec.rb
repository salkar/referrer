require 'rails_helper'

RSpec.describe Referrer::Session, type: :model do
  before :each do
    @user = Referrer::User.create!
  end

  before :each, with_sources: true do
    @session = @user.sessions.create!(active_from: 10.days.ago, active_until: 10.days.since)
    @source_0 = @session.sources.create!(referrer: 'http://test.com', entry_point: 'http://dummy.com',
                                       client_duplicate_id: 1, active_from: 7.days.ago)
    @source_1 = @session.sources.create!(referrer: 'http://test.com', entry_point: 'http://dummy.com',
                                       client_duplicate_id: 2, active_from: 5.days.ago)
    @source_2 = @session.sources.create!(referrer: 'http://test.com', entry_point: 'http://dummy.com',
                                       client_duplicate_id: 3, active_from: 2.days.ago)
  end

  describe 'scopes' do
    describe 'active_at' do
      it 'should work' do
        @user.sessions.create!(active_from: 10.days.ago, active_until: 7.days.ago)
        session_1 = @user.sessions.create!(active_from: 6.days.ago, active_until: 4.days.ago)
        @user.sessions.create!(active_from: 3.days.ago, active_until: 1.days.ago)
        expect(@user.sessions.active_at(5.days.ago)).to eq([session_1])
      end
    end
  end

  describe 'active period' do
    it 'should be correct by default' do
      session = @user.sessions.create!
      expect(session.active_until.to_i).to be_within(2).of((Time.now + Referrer.session_duration).to_i)
      expect(session.active_from.to_i).to be_within(2).of(Time.now.to_i)
    end

    it 'should be correct with custom values' do
      session = @user.sessions.create!(active_from: 10.days.ago, active_until: 10.days.since)
      expect(session.active_until.to_i).to be_within(2).of(10.days.since.to_i)
      expect(session.active_from.to_i).to be_within(2).of(10.days.ago.to_i)
    end
  end

  describe 'active seconds' do
    it 'should be correct' do
      session = @user.sessions.create!
      expect(session.active_seconds).to be_within(2).of(session.active_until - Time.now)
    end
  end

  describe 'source_at', with_sources: true do
    it 'should return correct source' do
      expect(@session.source_at(4.days.ago)).to eq(@source_1)
    end

    it 'should not return source' do
      expect(@session.source_at(8.days.ago)).to eq(nil)
    end
  end
end
