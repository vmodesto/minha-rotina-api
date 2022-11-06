module Events
  module Repositories
    class EventCategoriesRepository
      def self.build
        new(
          event_category_model: EventCategory
        )
      end

      def initialize(event_category_model:)
        @event_category_model = event_category_model
      end

      def get_by_id(id:)
        @event_category_model.find(id)
      end

      def get_all_categories
        @event_category_model.all
      end
    end
  end
end