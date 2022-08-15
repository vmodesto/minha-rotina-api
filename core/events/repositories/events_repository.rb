module Events
  module Repositories
    class EventsRepository
      def initialize(event_model: Event, event_factory: Events::Factories::EventFactory.new)
        @event_model = event_model
        @event_factory = event_factory
      end

      def find_by_event_and_user_id(event_id:, user_id:)
        event_model = @event_model.find_by(id: event_id, user_id: user_id)

        raise_event_not_found event_id unless event_model

        @event_factory.build_from_model event_model
      end

      def get_by_start_date_and_user_id(start_date:, user_id:)
        event_model_list = @event_model.by_start_date_and_user_id(start_date: start_date, user_id: user_id)

        return [] if event_model_list.empty?

        @event_factory.build_from_model_list event_model_list
      end

      def delete_by_event_and_user_id(event_id:, user_id:)
        event_model = @event_model.find_by(id: event_id, user_id: user_id)

        raise_event_not_found event_id unless event_model

        event_model.delete
      end

      def save(event)
        event_model = @event_model.find_or_initialize_by id: event.id
        event_model.user_id = event.user_id
        event_model.title = event.title
        event_model.description = event.description
        event_model.priority = event.priority
        event_model.start_date = event.start_date
        event_model.end_date = event.end_date
        event_model.status = event.status

        event_model.save!

        @event_factory.build_from_model event_model
      end

      private

      def raise_event_not_found(id)
        raise Events::Exceptions::EventNotFoundException.new "Evento não encontrado para o id: #{id}"
      end
    end
  end
end