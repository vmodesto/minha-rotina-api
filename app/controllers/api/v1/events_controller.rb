class Api::V1::EventsController < ApplicationController
  before_action :authenticate_user!

  rescue_from Events::Exceptions::EventNotFoundException do |error|
    render json: { message: error.message }, status: :not_found
  end

  def index
    result = user_events_repository.get_by_start_date(start_date: start_date)

    render json: { result: result.map(&:to_hash) }, status: :ok
  end

  def create
    use_case = Events::UseCases::CreateEvent.new(user_id: user_id)
    result = use_case.execute(event_params: event_params)

    render json: { result: result.to_hash }, status: :created
  rescue Events::Exceptions::InvalidEventException => error
    render json: { message: error.message }, status: :unprocessable_entity
  end

  def update
    use_case = Events::UseCases::UpdateEvent.new(user_id: user_id)
    result = use_case.execute(event_params: event_params)

    render json: { result: result.to_hash }, status: :ok
  rescue Events::Exceptions::InvalidEventException => error
    render json: { message: error.message }, status: :unprocessable_entity
  end

  def destroy
    user_events_repository.delete_by_id(id)

    head :no_content
  end

  private

  def user_events_repository
    Events::Repositories::UserEventsRepository.new(user_id: user_id)
  end

  def event_params
    event_hash = params.require(:event).permit(
      :title,
      :description,
      :priority,
      :start_date,
      :end_date
    ).to_hash

    event_hash.merge!(user_id: user_id)
    event_hash.merge!(id: id) if action_name.eql? "update"

    event_hash.with_indifferent_access
  end

  def user_id
    @current_user.id
  end

  def start_date
    params[:start_date]
  end

  def id
    params[:id]
  end
end