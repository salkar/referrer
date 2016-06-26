module Referrer
  class Source < ActiveRecord::Base
    belongs_to :session

    validates_presence_of :entry_point, :utm_source, :utm_campaign, :utm_medium, :utm_content, :utm_term, :session

    before_validation :fill_markup_fields

    class << self
      def markup_generator
        @markup_generator ||= begin
          mg = MarkupGenerator.new
          Referrer.markup_generator_settings.each do |k, v|
            mg.send(:"#{k}=", v)
          end
          mg
        end
      end
    end

    private

    def fill_markup_fields
      markup = self.class.markup_generator.generate(referrer, entry_point)
      %i{utm_source utm_campaign utm_medium utm_content utm_term}.each do |column_name|
        self.send(:"#{column_name}=", markup[column_name])
      end
    end
  end
end
