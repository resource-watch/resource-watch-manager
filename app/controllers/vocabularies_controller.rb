class VocabulariesController < ApplicationController
  before_action :check_user_authentication if Rails.env.production?
  before_action :check_permissions if Rails.env.production?

  def index
    gon.data = {
      authorization: 'Bearer ' + user_token
    }
  end

  private
    def user_token
      if session.has_key?(:user_token)
        session[:user_token]
      else
        ''
      end
    end
end
