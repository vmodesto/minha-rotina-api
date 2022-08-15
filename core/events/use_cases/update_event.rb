module Events
  module UseCases
    class UpdateEvent
      def initialize(events_repository: Events::Repositories::EventsRepository.new, event_factory: Events::Factories::EventFactory.new)
        @events_repository = events_repository
        @event_factory = event_factory
      end

      def execute(user_id:, event_params:)
        event = @events_repository.find_by_event_and_user_id(event_id: event_params[:id], user_id: user_id)
        event_hash = event.to_hash

        event_params = self.map_params(event_hash, event_params)

        event = @event_factory.build_from_hash event_params

        @events_repository.save event
      rescue => error
        raise Events::Exceptions::InvalidEventException.new error.message
      end

      private

      def map_params(event_hash, event_params)
        event_params[:id] = event_hash[:id]
        event_params[:user_id] = event_hash[:user_id]
        event_params[:title] ||= event_hash[:title]
        event_params[:description] ||= event_hash[:description]
        event_params[:start_date] ||= event_hash[:start_date]
        event_params[:end_date] ||= event_hash[:end_date]
        event_params[:priority] ||= event_hash[:priority]
        event_params[:status] ||= event_hash[:status]

        event_params
      end
    end
  end
end