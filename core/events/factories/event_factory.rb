module Events
  module Factories
    class EventFactory

      def build_from_hash(event_hash)
        event_hash = event_hash.with_indifferent_access

        Events::Domain::Event.new(
          id: event_hash[:id],
          title: event_hash[:title],
          description: event_hash[:description],
          start_date: Time.zone.parse(event_hash[:start_date] || ""),
          end_date: Time.zone.parse(event_hash[:end_date] || ""),
          priority: event_hash[:priority],
          status: event_hash[:status],
          user_id: event_hash[:user_id]
        )
      end

      def build_from_model_list(event_model_list)
        event_model_list.map {|event_model| build_from_model(event_model) }
      end

      def build_from_model(event_model)
        Events::Domain::Event.new(
          id: event_model.id,
          title: event_model.title,
          description: event_model.description,
          start_date: event_model.start_date,
          end_date: event_model.end_date,
          priority: event_model.priority,
          status: event_model.status,
          user_id: event_model.user_id
        )
      end
    end
  end
end