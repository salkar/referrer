require 'rails_helper'

RSpec.describe 'Controller additions for' do
  describe PostsController, type: :controller do
    before :each, with_referrer_user: true do
      @referrer_user = Referrer::User.create!
      request.cookies['referrer_user'] = "#{@referrer_user.id} #{@referrer_user.token}"
    end

    before :each, with_other_referrer_user: true do
      @other_referrer_user = Referrer::User.create!
    end

    before :each, with_main_app_user: true do
      @main_app_user = User.create!
      allow_any_instance_of(PostsController).to receive(:current_user).and_return(@main_app_user)
    end

    describe 'with main app user', with_main_app_user: true do
      describe 'with referrer user', with_referrer_user: true do
        describe 'on post request' do
          it 'should link users' do
            expect(@referrer_user.main_app_user).to eq(nil)
            post(:create, post: {title: 'test'})
            expect(@referrer_user.reload.main_app_user).to eq(@main_app_user)
          end
        end

        describe 'on get request' do
          it 'should link users' do
            expect(@referrer_user.main_app_user).to eq(nil)
            get(:new)
            expect(@referrer_user.reload.main_app_user).to eq(@main_app_user)
          end
        end
      end

      describe 'without referrer user' do
        it 'should not link users due no current referrer user', with_other_referrer_user: true do
          get(:new)
          expect(@other_referrer_user.reload.main_app_user).to eq(nil)
        end

        it 'should not link users due no referrer users' do
          post(:create, post:{title: 'test'})
        end
      end
    end

    describe 'without main app user' do
      describe 'with referrer user', with_referrer_user: true do
        describe 'on post request' do
          it 'should not link users' do
            expect(@referrer_user.main_app_user).to eq(nil)
            post(:create, post:{title: 'test'})
            expect(@referrer_user.reload.main_app_user).to eq(nil)
          end
        end

        describe 'on get request' do
          it 'should not link users' do
            expect(@referrer_user.main_app_user).to eq(nil)
            get(:index)
            expect(@referrer_user.reload.main_app_user).to eq(nil)
          end
        end
      end

      describe 'without referrer user' do
        it 'should not link users' do
          get(:index)
        end
      end
    end
  end
end
