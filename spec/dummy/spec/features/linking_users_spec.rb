require 'rails_helper'

RSpec.describe 'Linking users', watir: true do

  # This checks based on def current_user; User.first; end hack in dummy ApplicationController

  it 'should be done' do
    user = User.create!
    @browser.goto(@url)
    Watir::Wait.until{Referrer::Source.count == 1}
    @browser.refresh
    Watir::Wait.until{Referrer::Source.count == 2}
    expect(Referrer::User.count).to eq(1)
    expect(Referrer::User.first.linked_objects).to eq([user])
  end

  it 'should not be done' do
    2.times do
      source_count = Referrer::Source.count
      @browser.goto(@url)
      Watir::Wait.until{Referrer::Source.count > source_count}
      expect(Referrer::User.first.linked_objects).to eq([])
    end
  end
end