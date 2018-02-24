class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, unless: -> { request.format.json? }
  include ApplicationHelper
  include SessionsHelper
  
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :param_missing
  rescue_from CanCan::AccessDenied, with: :forbidden_access
  rescue_from App::Exception::InvalidParameter, with: :invalid_parameter
  rescue_from App::Exception::InsufficientPrivilege, with: :forbidden_access

  before_action :authenticate_user!

  def authenticate_user!
    unauthorized_access if !logged_in?
  end

  private
    def unauthorized_access
      render json: { error: _('errors.unauthorised_access') }, status: :unauthorized
    end

    def record_not_found
      render json: { error: _('errors.not_found') }, status: :not_found
    end

    def forbidden_access(exception)
      render json: { error: exception.message }, status: :forbidden
    end

    def invalid_parameter(exception)
      render json: { error: { message: exception.message } }, status: :bad_request
    end

    def param_missing
      render json: { error: _('errors.param_missing') }, status: :bad_request
    end
end
