# frozen_string_literal: true

module Api
  class ProfilesController < ApiController
    before_action :set_profile, only: [:show, :update, :destroy]

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
      if @profile.update_attributes(profile_params)
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
        begin
          @profile = Profile.find_by(user_id: params[:id])
        rescue ActiveRecord::RecordNotFound
          profile = Profile.new
          profile.errors.add(:id, "Wrong ID provided")
          render_error(profile, 404) and return
        end
      end

      def profile_params
        begin
          new_params = ActiveModelSerializers::Deserialization.jsonapi_parse(params)
          new_params = ActionController::Parameters.new(new_params)
          new_params.permit(:user_id, :avatar)
        rescue
          nil
        end
      end
  end
end
