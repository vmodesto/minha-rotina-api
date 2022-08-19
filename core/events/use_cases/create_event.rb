module Events
  module UseCases
    class CreateEvent
      def initialize(user_id:, user_events_repository: Events::Repositories::UserEventsRepository.new(user_id: user_id), event_factory: Events::Factories::EventFactory.new)
        @user_events_repository = user_events_repository
        @event_factory = event_factory
      end

      def execute(event_params:)
        event = @event_factory.build_from_hash event_params
        today = Time.zone.now

        raise_invalid_event_start_date event.start_date if event.start_date.before? today
        raise_invalid_event_end_date event.end_date if event.end_date.try(:before?, event.start_date)

        @user_events_repository.save event
      rescue => error
        raise Events::Exceptions::InvalidEventException.new error.message
      end

      private

      def raise_invalid_event_start_date(date)
        date = get_formatted_date(date)
        raise Events::Exceptions::InvalidEventException.new "Data #{date} inválida para o início do evento"
      end

      def raise_invalid_event_end_date(date)
        date = get_formatted_date(date)
        raise Events::Exceptions::InvalidEventException.new "Data #{date} inválida para o fim do evento"
      end

      def get_formatted_date(date)
        date.strftime("%d/%m/%Y %H:%M")
      end
    end
  end
end