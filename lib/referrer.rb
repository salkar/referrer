require 'referrer/engine'
require 'other/markup_generator'
require 'concerns/controllers/controller_additions'
require 'concerns/models/tracked_model_additions'
require 'concerns/models/owner_model_additions'
require 'modules/statistics'

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
