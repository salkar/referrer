require 'rails_helper'

RSpec.describe Referrer::User, type: :model do
  before :each do
    @user = Referrer::User.create!
  end

  before :each, with_main_app_user: true do
    @main_app_user = User.create!
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

  describe 'token' do
    it 'should be generated' do
      expect(@user.token.length).to be > 0
    end
  end

  describe 'link_with', with_main_app_user: true do
    it 'should work' do
      expect(@user.linked_with?(@main_app_user)).to eq(false)
      @user.link_with(@main_app_user)
      expect(@user.linked_with?(@main_app_user)).to eq(true)
    end
  end

  describe 'link_with?', with_main_app_user: true do
    it 'should return true' do
      @user.users_main_app_users.create(main_app_user: @main_app_user)
      expect(@user.users_main_app_users.size).to eq(1)
      expect(@user.linked_with?(@main_app_user)).to eq(true)
    end

    it 'should return false' do
      expect(@user.linked_with?(@main_app_user)).to eq(false)
    end
  end

  describe 'linked_objects' do
    it 'should return' do
      expect(@user.linked_objects).to eq([])
      @user.link_with(@main_app_user)
      expect(@user.reload.linked_objects).to eq([@main_app_user])
    end

    it 'should not return' do
      expect(@user.linked_objects).to eq([])
    end
  end

  describe 'source_at(time)' do
    it 'should return source', with_sources: true do
      expect(@user.source_at(4.days.ago)).to eq(@source_1)
    end

    it 'should not return source due no suitable sources', with_sources: true do
      expect(@session.source_at(8.days.ago)).to eq(nil)
    end

    it 'should not return source due no sessions' do
      expect(@user.source_at(4.days.ago)).to eq(nil)
    end
  end
end
