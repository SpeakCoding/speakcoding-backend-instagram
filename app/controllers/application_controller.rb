class ApplicationController < ActionController::API
  def render_errors(errors, status: 422)
    render json: {
      errors: errors.map do |paramerer, message| 
        { 
          source: { parameter: paramerer },
          detail: message
        }
      end
    }, status: 422
  end
end
