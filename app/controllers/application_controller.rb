class ApplicationController < ActionController::API
  def render_errors(errors, status: 422)
    render json: {
      errors: errors.map do |paramerer, message|
        {
          source: { parameter: paramerer },
          detail: message
        }
      end
    }, status: status
  end

  def render_unauthorized
    render json: {
      errors: [
        {
          detail: "You're not authorized to access this data"
        }
      ]
    }, status: 403
  end

  def current_user
    authentication_token = request.headers['Authentication-Token']
    return nil if authentication_token.blank?

    @current_user ||= User.find_by(authentication_token: authentication_token)
  end

  def require_current_user
    return if current_user.present?

    render json: { errors: [{ source: { parameter: 'user_id' }, detail: 'not authorized' }] }, status: 403
  end
end
