module Events
  module UseCases
    class CreateEvent
      def initialize(events_repository: Events::Repositories::EventsRepository.new, event_factory: Events::Factories::EventFactory.new)
        @events_repository = events_repository
        @event_factory = event_factory
      end

      def execute(user_id:, event_params:)
        event_params[:user_id] = user_id
        event = @event_factory.build_from_hash event_params

        @events_repository.save event
      rescue => error
        raise Events::Exceptions::InvalidEventException.new error.message
      end
    end
  end
end