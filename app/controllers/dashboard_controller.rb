# frozen_string_literal: true

# Dashboard controllerß
class DashboardController < ApplicationController
  before_action :check_user_authentication if Rails.env.production?

  def index; end
end
