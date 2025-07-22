class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  def sign_out
  end
end 