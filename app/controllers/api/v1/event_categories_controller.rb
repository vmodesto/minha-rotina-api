class Api::V1::EventCategoriesController < ApplicationController
  def index
    repository = Events::Repositories::EventCategoriesRepository.build

    render json: { result: repository.get_all_categories }, status: :ok
  end
end