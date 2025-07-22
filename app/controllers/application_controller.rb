class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # Optionally, add before_action :require_admin! to any admin controller
  def after_sign_out_path_for(resource_or_scope)
    sign_out_success_path
  end
end
