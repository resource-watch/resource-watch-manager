class HealthsController < ApplicationController
  def index
    render nothing: true, status: 200, content_type: 'text/html'
  end
end
