require 'rails_helper'

RSpec.describe 'Markup generator' do
  before :all do
    @mg = Referrer::MarkupGenerator.new
  end

  describe 'for direct channel' do
    it 'should work' do
      [[nil, nil],
       ['', ''],
       [nil, 'http:://dummy.com:3000/'],
       ['', 'http:://dummy.com:3000/']].each do |params|
        expect(@mg.generate(*params)).to eq({utm_source: '(direct)',
                                             utm_medium: '(none)',
                                             utm_campaign: '(none)',
                                             utm_content: '(none)',
                                             utm_term: '(none)',
                                             kind: 'direct'})
      end
    end
  end

  describe 'for utm channel' do
    it 'should work with all params' do
      [nil, '', 'http://test.com'].each do |referrer|
        expect(@mg.generate(
                   referrer,
                   'http://www.dummy.com/test/?utm_campaign=campaign&utm_medium=medium&utm_source=source&utm_term=term&utm_content=content'
               )).to eq({utm_source: 'source',
                         utm_medium: 'medium',
                         utm_campaign: 'campaign',
                         utm_content: 'content',
                         utm_term: 'term',
                         kind: 'utm'})
      end
    end

    it 'should work with several params' do
      expect(@mg.generate(
                 'http://www.test.com',
                 'http://www.dummy.com/test/?utm_campaign=campaign&utm_term=term'
             )).to eq({utm_source: '(none)',
                       utm_medium: '(none)',
                       utm_campaign: 'campaign',
                       utm_content: '(none)',
                       utm_term: 'term',
                       kind: 'utm'})
    end

    describe 'with utm synonyms' do
      it 'should work with synonyms and non-synonyms' do
        (mg = @mg.clone).utm_synonyms = {utm_campaign: 'custom_campaign', utm_source: %w(source custom_source)}
        expect(mg.generate(
                   'http://www.test.com',
                   'http://www.dummy.com/test/?custom_campaign=campaign&utm_term=term&source=source'
               )).to eq({utm_source: 'source',
                         utm_medium: '(none)',
                         utm_campaign: 'campaign',
                         utm_content: '(none)',
                         utm_term: 'term',
                         kind: 'utm'})
      end

      it 'should work with only synonyms' do
        (mg = @mg.clone).utm_synonyms = {utm_campaign: 'custom_campaign', utm_source: %w(source custom_source)}
        expect(mg.generate(
                   'http://www.test.com',
                   'http://www.dummy.com/test/?custom_campaign=campaign&source=source'
               )).to eq({utm_source: 'source',
                         utm_medium: '(none)',
                         utm_campaign: 'campaign',
                         utm_content: '(none)',
                         utm_term: '(none)',
                         kind: 'utm'})
      end
    end
  end

  describe 'for organic channel' do
    it 'should work' do
      expect(@mg.generate(
                 'https://www.google.ru/search?q=test&oq=test&sourceid=chrome&ie=UTF-8',
                 'http://www.dummy.com/'
             )).to eq({utm_source: 'google',
                       utm_medium: 'organic',
                       utm_campaign: '(none)',
                       utm_content: '(none)',
                       utm_term: 'test',
                       kind: 'organic'})
    end
  end

  describe 'for referral channel' do
    describe 'for default source' do
      it 'should work' do
        expect(@mg.generate(
                   'https://www.sub.test.com/a/b/?param=1#tag',
                   'http://www.dummy.com/'
               )).to eq({utm_source: 'sub.test.com',
                         utm_medium: 'referral',
                         utm_campaign: '(none)',
                         utm_content: '/a/b/?param=1#tag',
                         utm_term: '(none)',
                         kind: 'referral'})
      end
    end

    describe 'for custom source' do
      it 'should work' do
        expect(@mg.generate(
                   'https://www.t.co/test',
                   'http://www.dummy.com/'
               )).to eq({utm_source: 'twitter.com',
                         utm_medium: 'referral',
                         utm_campaign: '(none)',
                         utm_content: '/test',
                         utm_term: '(none)',
                         kind: 'referral'})
      end
    end
  end
end