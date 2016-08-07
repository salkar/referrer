require 'rails_helper'

RSpec.describe 'Owner model additions' do
  %w{User Company}.each do |main_app_user_class|
    describe "with main app user #{main_app_user_class}" do
      before :each do
        @main_app_user = Object.const_get(main_app_user_class).create!
        @user = Referrer::User.create!
      end

      before :each, with_users_relation: true do
        @user.link_with(@main_app_user)
      end

      before :each, with_sessions: true do
        @session = @user.sessions.create!(active_from: 10.days.ago)
        @session_1 = @user.sessions.create!(active_from: 5.days.ago)
      end

      before :each, with_sources: true do
        @session_source = @session.sources.create!(referrer: 'http://test.com', entry_point: 'http://dummy.com/?utm_source=0-0',
                                                   client_duplicate_id: 1, created_at: 9.days.ago)
        @session_source_1 = @session.sources.create!(referrer: 'http://test.com', entry_point: 'http://dummy.com/?utm_source=0-1',
                                                     client_duplicate_id: 1, created_at: 7.days.ago)
        @session_1_source = @session_1.sources.create!(referrer: 'http://test.com', entry_point: 'http://dummy.com/?utm_source=1-0',
                                                       client_duplicate_id: 1, created_at: 5.days.ago + 10.minutes)
        @session_1_source_1 = @session_1.sources.create!(referrer: '', entry_point: 'http://dummy.com/',
                                                         client_duplicate_id: 1, created_at: 4.days.ago)
      end

      describe 'relations' do
        describe 'referrer_users_main_app_users' do
          it 'should return main app user', with_users_relation: true do
            expect(@main_app_user.referrer_users_main_app_users.size).to eq(1)
            relation = @main_app_user.referrer_users_main_app_users.first
            expect(relation.user_id).to eq(@user.id)
          end

          it 'should not return associated users' do
            expect(@main_app_user.referrer_users_main_app_users).to eq([])
          end
        end
      end

      describe 'referrer_users' do
        it 'should be returned', with_users_relation: true do
          expect(@main_app_user.referrer_users).to eq([@user])
        end

        it 'should not be returned' do
          expect(@main_app_user.referrer_users).to eq([])
        end
      end

      describe 'referrer_sources' do
        it 'should be returned', with_users_relation: true, with_sessions: true, with_sources: true do
          expect(@main_app_user.referrer_sources).to eq([@session_source, @session_source_1, @session_1_source, @session_1_source_1])
        end

        it 'should not be returned without sources', with_users_relation: true, with_sessions: true do
          expect(@main_app_user.referrer_sources).to eq([])
        end

        it 'should not be returned without sessions', with_users_relation: true do
          expect(@main_app_user.referrer_sources).to eq([])
        end

        it 'should not be returned without referrer users' do
          expect(@main_app_user.referrer_sources).to eq([])
        end
      end

      describe 'referrer sources block', with_users_relation: true, with_sessions: true do
        describe 'referrer_first_source' do
          it 'should be returned', with_sources: true do
            expect(@main_app_user.referrer_first_source).to eq(@session_source)
          end

          it 'should not be returned' do
            expect(@main_app_user.referrer_first_source).to eq(nil)
          end
        end

        describe 'referrer_priority_source' do
          it 'should be returned', with_sources: true do
            expect(@main_app_user.referrer_priority_source).to eq(@session_1_source)
          end

          it 'should not be returned' do
            expect(@main_app_user.referrer_priority_source).to eq(nil)
          end
        end

        describe 'referrer_last_source' do
          it 'should be returned', with_sources: true do
            expect(@main_app_user.referrer_last_source).to eq(@session_1_source_1)
          end

          it 'should not be returned' do
            expect(@main_app_user.referrer_last_source).to eq(nil)
          end
        end

        describe 'referrer_markups', with_users_relation: true, with_sessions: true do
          it 'should return correct data', with_sources: true do
            expect(@main_app_user.referrer_markups).
                to eq({first: {utm_source: '0-0', utm_campaign: '(none)', utm_medium: '(none)', utm_content: '(none)',
                               utm_term: '(none)', kind: 'utm'},
                       priority: {utm_source: '1-0', utm_campaign: '(none)', utm_medium: '(none)', utm_content: '(none)',
                                  utm_term: '(none)', kind: 'utm'},
                       last: {utm_source: '(direct)', utm_campaign: '(none)', utm_medium: '(none)', utm_content: '(none)',
                              utm_term: '(none)', kind: 'direct'}})
          end

          it 'should return empty data' do
            expect(@main_app_user.referrer_markups).to eq({first: nil, priority: nil, last: nil})
          end
        end
      end
    end
  end
end
