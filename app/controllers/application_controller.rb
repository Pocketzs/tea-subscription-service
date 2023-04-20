class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActionController::ParameterMissing, with: :render_parameter_missing_response 

  def render_unprocessable_entity_response(exception)
    # serialize error takes the arguments (exception, status, message) in that order
    render json: ErrorSerializer.serialize_error(exception, :bad_request, "Record Invalid"), status: :bad_request
  end

  def render_not_found_response(exception)
    # serialize error takes the arguments (exception, status, message) in that order
    render json: ErrorSerializer.serialize_error(exception, :not_found, "Record not Found"), status: :not_found
  end

  def render_parameter_missing_response(exception)
    render json: ErrorSerializer.serialize_error(exception, :bad_request, "Parameter Required"), status: :bad_request
  end
end
