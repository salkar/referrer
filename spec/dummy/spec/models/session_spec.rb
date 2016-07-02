require 'rails_helper'

RSpec.describe Referrer::Source, type: :model do
  before :all do
    @class = Referrer::Source
  end

  before :each do
    @user = Referrer::User.create!
  end

  describe 'active until' do
    it 'should be correct' do
      session = @user.sessions.create!
      expect(session.active_until).to be > Time.now
    end
  end

  describe 'active seconds' do
    it 'should be correct' do
      session = @user.sessions.create!
      expect(session.active_seconds).to be_within(2).of(session.active_until - Time.now)
    end
  end
end
