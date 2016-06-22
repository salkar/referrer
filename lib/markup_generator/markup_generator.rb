module Referrer
  class MarkupGenerator
    DEFAULT_ORGANICS = [
        {host: 'search.daum.net', param: 'q'},
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
        {host: 'search.tut.by', param: 'query'}
    ]

    CUSTOM_REFERRALS = [
        { host: /^(www\.)?t\.co$/, display: 'twitter.com' },
        { host: /^(www\.)?plus\.url\.google\.com$/, display: 'plus.google.com' }
    ]

    attr_accessor :organics, :referrals

    def initialize

    end
  end
end