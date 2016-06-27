require 'referrer/engine'
require 'markup_generator/markup_generator'

module Referrer
  mattr_accessor(:markup_generator_settings){{}}
  mattr_accessor(:sources_overwriting_schema) do
    {direct: %w(direct),
     referral: %w(direct referral organic utm),
     organic: %w(direct referral organic utm),
     utm: %w(direct referral organic utm)}
  end
end
