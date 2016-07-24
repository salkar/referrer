require 'rails_helper'

RSpec.describe 'JS part', watir: true do
  describe 'user' do
    it 'should be created' do
      expect(Referrer::User.count).to eq(0)
      @browser.goto(@url)
      Watir::Wait.until{Referrer::User.count == 1}
      user = Referrer::User.last
      Watir::Wait.until{Referrer::Session.count == 1}
      expect(JSON.parse(URI.decode(@browser.cookies.to_a.detect{|c| c[:name] == 'referrer_user'}[:value])))
          .to eq({'id' => user.id, 'token' => user.token})
    end

    it 'should not be overwritten' do
      @browser.goto(@url)
      Watir::Wait.until{Referrer::User.count == 1}
      user = Referrer::User.last
      Watir::Wait.until{Referrer::Session.count == 1}
      @browser.refresh
      Watir::Wait.until{Referrer::Source.count == 2}
      expect(Referrer::User.count).to eq(1)
      expect(JSON.parse(URI.decode(@browser.cookies.to_a.detect{|c| c[:name] == 'referrer_user'}[:value])))
          .to eq({'id' => user.id, 'token' => user.token})
    end
  end

  describe 'session' do
    it 'should be created' do
      expect(Referrer::Session.count).to eq(0)
      @browser.goto(@url)
      Watir::Wait.until{Referrer::Session.count == 1}
      session = Referrer::Session.last
      expect(session.user).to eq(Referrer::User.first)
      Watir::Wait.until{Referrer::Source.count == 1}
      expect(@browser.cookies.to_a.detect{|c| c[:name] == 'referrer_session_id'}[:value]).to eq(session.id.to_s)
    end

    it 'should not be overwritten' do
      @browser.goto(@url)
      Watir::Wait.until{Referrer::Session.count == 1}
      session = Referrer::Session.first
      Watir::Wait.until{Referrer::Source.count == 1}
      @browser.refresh
      Watir::Wait.until{Referrer::Source.count == 2}
      expect(Referrer::Session.count).to eq(1)
      expect(@browser.cookies.to_a.detect{|c| c[:name] == 'referrer_session_id'}[:value]).to eq(session.id.to_s)
    end

    it 'should be overwritten due new user' do
      @browser.goto(@url)
      Watir::Wait.until{Referrer::Session.count == 1}
      Watir::Wait.until{@browser.execute_script('return window.referrer.finished;');}
      @browser.cookies.delete('referrer_user')
      @browser.refresh
      Watir::Wait.until{Referrer::Source.count == 2}
      expect(Referrer::Session.count).to eq(2)
      new_session = Referrer::Session.last
      expect(Referrer::User.count).to eq(2)
      expect(new_session.user).to eq(Referrer::User.last)
      expect(@browser.cookies.to_a.detect{|c| c[:name] == 'referrer_session_id'}[:value]).to eq(new_session.id.to_s)
    end
  end

  describe 'source' do
    it 'should be created' do
      @browser.goto(@url)
      Watir::Wait.until{Referrer::Source.count == 1}
      source = Referrer::Source.last
      expect(source.session.present?).to eq(true)
      expect(source.referrer).to eq('')
      expect(source.entry_point).to eq('http://localhost:3000/')
    end
  end

end