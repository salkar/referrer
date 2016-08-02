module Referrer
  class Source < ActiveRecord::Base
    belongs_to :session

    validates_presence_of :entry_point, :utm_source, :utm_campaign, :utm_medium, :utm_content, :utm_term, :session,
                          :kind, :client_duplicate_id, :active_from

    before_validation :fill_markup_fields, :set_active_from, on: :create
    before_create :set_priority

    scope :prioritized, -> {where(priority: true)}

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

    def to_markup
      attributes.slice(*%w{utm_source utm_campaign utm_medium utm_content utm_term kind})
    end

    private

    def fill_markup_fields
      markup = self.class.markup_generator.generate(referrer, entry_point)
      %i{utm_source utm_campaign utm_medium utm_content utm_term kind}.each do |column_name|
        self.send(:"#{column_name}=", markup[column_name])
      end
    end

    def set_priority
      previous_priority_source = session.sources.where(priority: true).last
      if previous_priority_source.blank? ||
          Referrer.sources_overwriting_schema[kind.to_sym].include?(previous_priority_source.kind)
        self.priority = true
      end
    end

    def set_active_from
      self.active_from = Time.now unless active_from
    end
  end
end
