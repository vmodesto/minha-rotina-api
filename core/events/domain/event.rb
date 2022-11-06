module Events
  module Domain
    class Event
      attr_reader :id, :user_id, :title, :description, :start_date, :end_date, :status, :priority, :category

      def initialize(id: nil, user_id:, title:, description:, start_date:, end_date: nil, status:, priority:, category:)
        @id = id
        @user_id = user_id
        @title = title
        @description = description
        @start_date = start_date
        @end_date = end_date
        @status = status || "created"
        @priority = priority || "normal"
        @category = category
      end

      def duration
        return nil unless @end_date

        minutes = (@end_date - @start_date) / 60
        minutes.round
      end

      def category_name
        @category&.name
      end

      def to_hash
        {
          id: @id,
          user_id: @user_id,
          title: @title,
          description: @description,
          start_date: @start_date.to_s,
          end_date: @end_date&.to_s,
          status: @status,
          priority: @priority,
          duration: self.duration,
          category_id: @category&.id,
          category_name: self.category_name
        }
      end
    end
  end
end