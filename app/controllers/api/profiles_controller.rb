# frozen_string_literal: true

module Api
  class ProfilesController < ApiController
    before_action :set_profile, only: %i[show update destroy]

    def show
      render json: @profile
    end

    def create
      profile = Profile.new(profile_params)
      if profile.save
        render json: profile, status: :created
      else
        render_error(profile, :unprocessable_entity)
      end
    end

    def update
      if @profile.update(profile_params)
        render json: @profile, status: :ok
      else
        render_error(@profile, :unprocessable_entity)
      end
    end

    def destroy
      @profile.destroy
      head 204
    end

    private

    def set_profile
      @profile = Profile.find_by(user_id: params[:id])
    rescue ActiveRecord::RecordNotFound
      profile = Profile.new
      profile.errors.add(:id, 'Wrong ID provided')
      render_error(profile, 404) && return
    end

    def profile_params
      ParamsHelper.permit(params, :user_id, :avatar)
    rescue
      nil
    end
  end
end
