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
end
