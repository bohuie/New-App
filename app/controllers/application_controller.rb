class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def default_pagination_params
    {:page => params[:page], :per_page => 20}
  end
end
