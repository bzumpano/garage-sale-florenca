class ApplicationController < ActionController::Base
  before_action :set_browser_compatibility_headers
  
  private
  
  def set_browser_compatibility_headers
    # Ensure proper content negotiation for all browsers, especially mobile
    request.format = :html if request.format == Mime[:html]
    
    # Set comprehensive headers to prevent 406 errors
    response.headers['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8'
    response.headers['Accept-Language'] = 'en-US,en;q=0.9,pt-BR;q=0.8,pt;q=0.7'
    response.headers['Accept-Encoding'] = 'gzip, deflate, br'
    response.headers['Cache-Control'] = 'no-cache'
    response.headers['X-Content-Type-Options'] = 'nosniff'
    
    # Ensure proper content type for mobile browsers
    if request.user_agent&.include?('Mobile')
      response.headers['Content-Type'] = 'text/html; charset=utf-8'
    end
  end
  
  def after_sign_out_path_for(resource_or_scope)
    sign_out_success_path
  end
end
