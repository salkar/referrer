require 'rails_helper'

RSpec.describe Referrer::Source, type: :model do
  before :all do
    @class = Referrer::Source
  end

  before :each do
    Referrer.markup_generator_settings = {}
    @class.instance_variable_set(:@markup_generator, nil)
  end

  before :each, with_session: true do
    @user = Referrer::User.create!
    @session = @user.sessions.create!
  end

  describe 'markup generator' do
    it 'should be initialized only once' do
      expect(@class.markup_generator.__id__).to eq(@class.markup_generator.__id__)
    end

    it 'should be itinialized with custom params' do
      custom_params = {
          organics: Referrer::MarkupGenerator::ORGANICS << {host: 'search.test.test', param: 'query'},
          referrals: Referrer::MarkupGenerator::REFERRALS << {host: /^(www\.)?test1\.test$/, display: 'test1.test'},
          utm_synonyms: {utm_campaign: 'custom_campaign'},
          array_params_joiner: '|'
      }
      Referrer.markup_generator_settings = custom_params
      mg = @class.markup_generator
      custom_params.each do |k, v|
        expect(mg.send(k)).to eq(v)
      end
    end
  end

  describe 'utm markup', with_session: true do
    it 'should be created before creation' do
      source = @session.sources.new(referrer: 'http://test.com/a', entry_point: 'https://www.dummy.com/welcome', client_duplicate_id: 1)
      source.save!
      expect(source.utm_campaign).to eq('(none)')
      expect(source.utm_source).to eq('test.com')
      expect(source.utm_medium).to eq('referral')
      expect(source.utm_content).to eq('/a')
      expect(source.utm_term).to eq('(none)')
      expect(source.kind).to eq('referral')
    end
  end

  describe 'priority', with_session: true do
    describe 'for first source' do
      it 'should set' do
        [['', 'http://dummy.com'],
         ['http://test.com', 'http://dummy.com'],
         ['http://google.com/?q=query', 'http://dummy.com'],
         ['http://test.com/?utm_source=source', 'http://dummy.com']].each do |arr|
          @session.sources.destroy_all
          source = @session.sources.create!(referrer: arr[0], entry_point: arr[1], client_duplicate_id: 1)
          expect(source.priority).to eq(true)
        end
      end
    end

    describe 'for several sources' do
      it 'should set' do
        @session.sources.create!(referrer: '', entry_point: 'https://www.dummy.com/welcome', client_duplicate_id: 1)
        expect(@session.sources.create!(referrer: '', entry_point: 'https://www.dummy.com/welcome', client_duplicate_id: 2).priority).to eq(true)
        expect(@session.sources.create!(referrer: 'http://test.com', entry_point: 'https://www.dummy.com/welcome', client_duplicate_id: 3).priority).to eq(true)
      end

      it 'should not set' do
        @session.sources.create!(referrer: 'http://test.com', entry_point: 'https://www.dummy.com/welcome', client_duplicate_id: 1)
        expect(@session.sources.create!(referrer: '', entry_point: 'https://www.dummy.com/welcome', client_duplicate_id: 2).priority).to eq(false)
      end
    end

    describe 'to_markup' do
      it 'should be correct' do
        source = @session.sources.create!(referrer: 'http://test.com/a', entry_point: 'https://www.dummy.com/welcome',
                                          client_duplicate_id: 1)
        expect(source.to_markup).to eq({'utm_source'=>'test.com', 'utm_campaign'=>'(none)', 'utm_medium'=>'referral',
                                        'utm_content'=>'/a', 'utm_term'=>'(none)', 'kind'=>'referral'})
      end
    end
  end
end