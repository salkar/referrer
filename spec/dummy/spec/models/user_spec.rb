require 'rails_helper'

RSpec.describe Referrer::User, type: :model do
  before :each do
    @user = Referrer::User.create!
  end

  before :each, with_main_app_user: true do
    @main_app_user = User.create!
  end

  describe 'token' do
    it 'should be generated' do
      expect(@user.token.length).to be > 0
    end
  end

  describe 'main app user', with_main_app_user: true do
    it 'should be' do
      @user.main_app_user = @main_app_user
      @user.save!
      expect(@user.main_app_user).to eq(@main_app_user)
    end

    it 'should not be' do
      expect(@user.main_app_user).to eq(nil)
    end
  end
end
