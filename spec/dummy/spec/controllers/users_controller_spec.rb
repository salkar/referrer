require 'rails_helper'

RSpec.describe Referrer::UsersController, type: :controller do
  routes { Referrer::Engine.routes }

  describe 'create' do
    it 'should be done' do
      expect(Referrer::User.all.count).to eq(0)
      post(:create)
      expect(Referrer::User.all.count).to eq(1)
      user = Referrer::User.last
      result = JSON.parse(response.body)
      expect(result.keys).to eq(%w(id token))
      expect(result['id']).to eq(user.id)
      expect(result['token']).to eq(user.token)
    end
  end
end