class Api::V1::EventsController < ApplicationController
  before_action :authenticate_user!

  rescue_from Events::Exceptions::EventNotFoundException do |error|
    render json: { message: error.message }, status: :not_found
  end

  def index
    repository = Events::Repositories::EventsRepository.new
    result = repository.get_by_start_date_and_user_id(start_date: start_date, user_id: user_id)

    render json: { result: result.map(&:to_hash) }, status: :ok
  end

  def create
    use_case = Events::UseCases::CreateEvent.new
    result = use_case.execute(user_id: user_id, event_params: event_params)

    render json: { result: result.to_hash }, status: :created
  rescue Events::Exceptions::InvalidEventException => error
    render json: { message: error.message }, status: :unprocessable_entity
  end

  def update
    use_case = Events::UseCases::UpdateEvent.new
    result = use_case.execute(user_id: user_id, event_params: event_params)

    render json: { result: result.to_hash }, status: :ok
  rescue Events::Exceptions::InvalidEventException => error
    render json: { message: error.message }, status: :unprocessable_entity
  end

  def destroy
    repository = Events::Repositories::EventsRepository.new
    repository.delete_by_event_and_user_id(event_id: id, user_id: user_id)

    head :no_content
  end

  private

  def event_params
    event_hash = params.require(:event).permit(
      :title,
      :description,
      :priority,
      :start_date,
      :end_date
    ).to_hash

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