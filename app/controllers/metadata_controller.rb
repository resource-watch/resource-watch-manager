class MetadataController < ApplicationController

  before_action :check_user_authentication if Rails.env === 'production'

  def index
    puts 'asdfaskdfkahjgdsf gjhasdff ghjkfadsgjk fsadgjkfsadk f jghkfds kfghjkf ghjd adfjk fghjkf jgkjkgh adfsjkgh adfsjhk gadfs'
    gon.data = {
      authorization: 'Bearer ' + user_token,
      id: params[:id]
    }
  end

  def new
    gon.data = {
      authorization: 'Bearer ' + user_token
    }
  end

  def edit
    gon.data = {
      authorization: 'Bearer ' + user_token,
      id: params[:id]
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
