require 'rails_helper'

RSpec.describe Referrer::SourcesTrackedObject, type: :model do
  before :each, with_data: true do
    @user = Referrer::User.create!
    @request = Request.create!
    @session = @user.sessions.create!(active_from: 10.days.ago, active_until: 10.days.since)
  end

  before :each, with_source: true do
    @source = @session.sources.create!(referrer: 'http://test.com', entry_point: 'http://dummy.com',
                                       client_duplicate_id: 1, created_at: 5.days.ago)
  end

  describe 'should be created', with_data: true do
    it 'with source', with_source: true do
      sto = Referrer::SourcesTrackedObject.create(trackable: @request, user: @user)
      expect(sto.new_record?).to eq(false)
      expect(sto.user).to eq(@user)
      expect(sto.trackable).to eq(@request)
      expect(sto.source).to eq(@source)
      expect(sto.linked_at.to_i).to be_within(2).of(Time.now.to_i)
    end

    it 'without source' do
      sto = Referrer::SourcesTrackedObject.create(trackable: @request, user: @user)
      expect(sto.new_record?).to eq(false)
      expect(sto.user).to eq(@user)
      expect(sto.trackable).to eq(@request)
      expect(sto.source).to eq(nil)
      expect(sto.linked_at.to_i).to be_within(2).of(Time.now.to_i)
    end

    it 'with custom linked_at' do
      sto = Referrer::SourcesTrackedObject.create(trackable: @request, user: @user, linked_at: 2.days.ago)
      expect(sto.new_record?).to eq(false)
      expect(sto.linked_at.to_i).to be_within(2).of(2.days.ago.to_i)
    end
  end

  describe 'should not be created' do
    it 'due validations errors' do
      sto = Referrer::SourcesTrackedObject.create
      expect(sto.new_record?).to eq(true)
      expect(sto.errors.size).to be > 0
    end
  end
end
