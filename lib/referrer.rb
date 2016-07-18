require 'referrer/engine'
require 'markup_generator/markup_generator'
require 'controller_additions/controller_additions'

module Referrer
  mattr_accessor(:markup_generator_settings){{}}
  mattr_accessor(:sources_overwriting_schema) do
    {direct: %w(direct),
     referral: %w(direct referral organic utm),
     organic: %w(direct referral organic utm),
     utm: %w(direct referral organic utm)}
  end
  mattr_accessor(:session_duration){3.months}
  mattr_accessor(:current_user_method_name){:current_user}
  mattr_accessor(:js_settings) {{}}
  mattr_accessor(:js_csrf_token) do
    <<-JS
      var tokenContainer = document.querySelector("meta[name=csrf-token]");
      return tokenContainer ? tokenContainer.content : null;
    JS
  end
end
