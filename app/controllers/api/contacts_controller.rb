# frozen_string_literal: true

module Api
  # API class for the Faqs Resource
  class ContactsController < ApiController
    skip_before_action :authenticate, only: [:create]

    def create
      begin
        ContactMailer.contact_us_email(params[:email], params[:text]).deliver
        render status: :created
      rescue Exception => e
        Rails.logger.error "Error sending the email: #{e}"
        render status: :unprocessable_entity
      end
    end
  end
end
