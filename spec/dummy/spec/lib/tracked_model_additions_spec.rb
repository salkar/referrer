require 'rails_helper'

RSpec.describe 'Tracked model additions' do
  before :each do
    @user = Referrer::User.create!
    @request = Request.create!
  end

  before :each, with_current_source: true do
    @session = @user.sessions.create!(active_from: 10.days.ago, active_until: 10.days.since)
    @source = @session.sources.create!(referrer: 'http://test.com', entry_point: 'http://dummy.com',
                                       client_duplicate_id: 1, active_from: 5.days.ago)
  end

  describe 'referrer_link_with' do
    describe 'should link', with_current_source: true do
      it 'by default' do
        @request.referrer_link_with(@user)
        expect(Referrer::SourcesTrackedObject.count).to eq(1)
        relation = Referrer::SourcesTrackedObject.first
        expect(relation.trackable).to eq(@request)
        expect(relation.user).to eq(@user)
        expect(relation.source).to eq(@source)
        expect(relation.linked_at.to_i).to be_within(2).of(Time.now.to_i)
      end

      it 'with custom linked_at time' do
        @request.referrer_link_with(@user, linked_at: 1.day.ago)
        expect(Referrer::SourcesTrackedObject.count).to eq(1)
        relation = Referrer::SourcesTrackedObject.first
        expect(relation.linked_at.to_i).to be_within(2).of(1.day.ago.to_i)
      end

      it 'with ! method version' do
        @request.referrer_link_with!(@user)
        expect(Referrer::SourcesTrackedObject.count).to eq(1)
      end
    end

    describe 'should not link' do
      it 'with default version' do
        @request.referrer_link_with(nil)
        expect(Referrer::SourcesTrackedObject.count).to eq(0)
      end

      it 'with ! method version' do
        expect{@request.referrer_link_with!(nil)}.to raise_error(/Validation/)
        expect(Referrer::SourcesTrackedObject.count).to eq(0)
      end
    end
  end
end