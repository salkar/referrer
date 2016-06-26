module Referrer
  class MarkupGenerator
    UTM_KEYS = %w(utm_source utm_medium utm_campaign utm_content utm_term)

    attr_accessor :organics, :referrals, :utm_synonyms, :array_params_joiner

    def initialize
      @organics = [{host: 'search.daum.net', param: 'q'},
                   {host: 'search.naver.com', param: 'query'},
                   {host: 'search.yahoo.com', param: 'p'},
                   {host: /^(www\.)?google\.[a-z]+$/, param: 'q', display: 'google'},
                   {host: 'www.bing.com', param: 'q'},
                   {host: 'search.aol.com', params: 'q'},
                   {host: 'search.lycos.com', param: 'q'},
                   {host: 'edition.cnn.com', param: 'text'},
                   {host: 'index.about.com', param: 'q'},
                   {host: 'mamma.com', param: 'q'},
                   {host: 'ricerca.virgilio.it', param: 'qs'},
                   {host: 'www.baidu.com', param: 'wd'},
                   {host: /^(www\.)?yandex\.[a-z]+$/, param: 'text', display: 'yandex'},
                   {host: 'search.seznam.cz', param: 'oq'},
                   {host: 'www.search.com', param: 'q'},
                   {host: 'search.yam.com', param: 'k'},
                   {host: 'www.kvasir.no', param: 'q'},
                   {host: 'buscador.terra.com', param: 'query'},
                   {host: 'nova.rambler.ru', param: 'query'},
                   {host: 'go.mail.ru', param: 'q'},
                   {host: 'www.ask.com', param: 'q'},
                   {host: 'searches.globososo.com', param: 'q'},
                   {host: 'search.tut.by', param: 'query'}]
      @referrals = [{host: /^(www\.)?t\.co$/, display: 'twitter.com'},
                    {host: /^(www\.)?plus\.url\.google\.com$/, display: 'plus.google.com'}]
      @utm_synonyms = UTM_KEYS.inject({}){|r, key| r.merge({key => []})}
      @array_params_joiner = ', '
    end

    def generate(referrer, entry_point)
      referrer_uri, entry_point_uri = *[referrer, entry_point].map{|url| URI(URI::encode(url || ''))}
      referrer_params, entry_point_params = *[referrer_uri, entry_point_uri].map{|uri| uri_params(uri)}
      prepare_result(utm(entry_point_params) || organic(referrer_uri, referrer_params) ||
                         referral(referrer_uri) || direct)
    end

    private

    def uri_params(uri)
      Rack::Utils.parse_query(uri.try(:query))
    end

    def base_result
      UTM_KEYS.inject({}){|r, key| r.merge!(key => '(none)')}
    end

    def check_host(option, value)
      case option
        when String
          option == value
        when Regexp
          option =~ value
        else
          false
      end
    end

    def prepare_result(markup)
      Hash[markup.map{|k, v| [k, v.is_a?(Array) ? v.join(array_params_joiner) : v]}].symbolize_keys
    end

    def utm(entry_point_params)
      if (entry_point_params.keys & (UTM_KEYS + utm_synonyms.values.flatten)).present?
        UTM_KEYS.inject(base_result) do |r, key|
          values = if utm_synonyms[key.to_sym].present?
                     [].push(entry_point_params[key]).push([utm_synonyms[key.to_sym]].flatten.map do |synonym_key|
                                                             entry_point_params[synonym_key]
                                                           end)
                   else
                     [entry_point_params[key]]
                   end.flatten.compact.map{|value| URI::decode(value)}
          values.present? ? r.merge!({key => values}) : r
        end
      end
    end

    def organic(referrer_uri, referrer_params)
      if referrer_uri.to_s.present? &&
          current_organic = organics.detect{|organic| check_host(organic[:host], referrer_uri.host)}
        base_result.merge!({'utm_source' => current_organic[:display] || current_organic[:host].split('.')[-2],
                            'utm_medium' => 'organic',
                            'utm_term' => referrer_params[current_organic[:param]] || '(none)'})
      end
    end

    def referral(referrer_uri)
      if referrer_uri.to_s.present?
        custom_referral = referrals.detect{|referral| check_host(referral[:host], referrer_uri.host)}
        base_result.merge!(
            'utm_source' => custom_referral ? custom_referral[:display] : referrer_uri.host.gsub('www.', ''),
            'utm_medium' => 'referral',
            'utm_content' => URI::decode(referrer_uri.request_uri) || '(none)'
        )
      end
    end

    def direct
      base_result.merge!('utm_source' => '(direct)')
    end
  end
end