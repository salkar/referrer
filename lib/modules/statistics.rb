module Referrer
  module Statistics
    class << self
      def sources_markup(from, to)
        Referrer::Source.where('created_at >= ? AND created_at <= ?', from, to).group_by do |source|
          source.to_markup.symbolize_keys!
        end.map do |markup, matches|
          markup.merge({count: matches.size})
        end
      end

      def tracked_objects_markup(from, to, type: nil)
        result = Referrer::SourcesTrackedObject.where('linked_at >= ? AND linked_at <= ?', from, to).includes(:source)
        result = result.where(trackable_type: type) if type.present?
        result.map{|item| item.source}.select do |source|
          source.present?
        end.group_by do |source|
          source.to_markup.symbolize_keys!
        end.map do |markup, matches|
          markup.merge({count: matches.size})
        end
      end
    end
  end
end
