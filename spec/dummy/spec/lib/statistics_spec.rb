require 'rails_helper'

RSpec.describe 'Statistics' do
  before :each do
    @user = Referrer::User.create!
    @session = @user.sessions.create!(active_from: 10.days.ago, active_until: 5.days.ago + 10.minutes)
    @session_1 = @user.sessions.create!(active_from: 5.days.ago + 10.minutes)
    @session_source = @session.sources.create!(referrer: 'http://test.com', entry_point: 'http://dummy.com/?utm_source=0-0',
                                               client_duplicate_id: 1, created_at: 9.days.ago)
    @session_source_1 = @session.sources.create!(referrer: 'http://test.com', entry_point: 'http://dummy.com/?utm_source=0-0',
                                                 client_duplicate_id: 1, created_at: 7.days.ago)
    @session_1_source = @session_1.sources.create!(referrer: 'http://test.com', entry_point: 'http://dummy.com/?utm_source=1-0',
                                                   client_duplicate_id: 1, created_at: 5.days.ago + 10.minutes)
    @session_1_source_1 = @session_1.sources.create!(referrer: '', entry_point: 'http://dummy.com/',
                                                     client_duplicate_id: 1, created_at: 3.days.ago)
  end

  describe 'sources_markup' do
    it 'should return data' do
      result = Referrer::Statistics.sources_markup(10.days.ago, 2.days.ago)
      expect(result).
          to eq([{utm_source: '0-0', utm_campaign: '(none)', utm_medium: '(none)', utm_content: '(none)',
                  utm_term: '(none)', kind: 'utm', count: 2},
                 {utm_source: '1-0', utm_campaign: '(none)', utm_medium: '(none)', utm_content: '(none)',
                  utm_term: '(none)', kind: 'utm', count: 1},
                 {utm_source: '(direct)', utm_campaign: '(none)', utm_medium: '(none)', utm_content: '(none)',
                  utm_term: '(none)', kind: 'direct', count: 1}])
    end

    it 'should return part of data' do
      result = Referrer::Statistics.sources_markup(8.days.ago, 4.days.ago)
      expect(result).
          to eq([{utm_source: '0-0', utm_campaign: '(none)', utm_medium: '(none)', utm_content: '(none)',
                  utm_term: '(none)', kind: 'utm', count: 1},
                 {utm_source: '1-0', utm_campaign: '(none)', utm_medium: '(none)', utm_content: '(none)',
                  utm_term: '(none)', kind: 'utm', count: 1}])
    end

    it 'should not return data' do
      expect(Referrer::Statistics.sources_markup(20.days.ago, 10.days.ago)).to eq([])
    end
  end

  describe 'tracked_objects_markup' do
    before :each do
      @user_1 = Referrer::User.create!
      @request = Request.create!
      @request_1 = Request.create!
      @support = Support.create!
      @support_1 = Support.create!
      Request.create!
      Support.create!
      @request.referrer_link_with(@user, linked_at: 8.days.ago)
      @request_1.referrer_link_with(@user_1, linked_at: 6.days.ago)
      @support.referrer_link_with(@user, linked_at: 6.days.ago)
      @support_1.referrer_link_with(@user, linked_at: 4.days.ago)
    end

    it 'should return data' do
      result = Referrer::Statistics.tracked_objects_markup(10.days.ago, 2.days.ago)
      expect(result).to eq([{utm_source: '0-0', utm_campaign: '(none)', utm_medium: '(none)', utm_content: '(none)', 
                             utm_term: '(none)', kind: 'utm', count: 2}, 
                            {utm_source: '1-0', utm_campaign: '(none)', utm_medium: '(none)', utm_content: '(none)', 
                             utm_term: '(none)', kind: 'utm', count: 1}])
    end

    it 'should return data only for one class' do
      result = Referrer::Statistics.tracked_objects_markup(10.days.ago, 2.days.ago, type: 'Request')
      expect(result).to eq([{utm_source: '0-0', utm_campaign: '(none)', utm_medium: '(none)', utm_content: '(none)',
                             utm_term: '(none)', kind: 'utm', count: 1}])
    end

    it 'should return part of data' do
      result = Referrer::Statistics.tracked_objects_markup(7.days.ago, 2.days.ago)
      expect(result).to eq([{utm_source: '0-0', utm_campaign: '(none)', utm_medium: '(none)', utm_content: '(none)',
                             utm_term: '(none)', kind: 'utm', count: 1},
                            {utm_source: '1-0', utm_campaign: '(none)', utm_medium: '(none)', utm_content: '(none)',
                             utm_term: '(none)', kind: 'utm', count: 1}])
    end

    it 'should not return data' do
      expect(Referrer::Statistics.tracked_objects_markup(20.days.ago, 15.days.ago)).to eq([])
    end
  end
end
