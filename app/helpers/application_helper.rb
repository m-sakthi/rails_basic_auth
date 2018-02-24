module ApplicationHelper
  def render_model_errors(object)
    render 'shared/model_errors', locals: { object: object }, status: :bad_request
  end
end
