class WidgetService < ApiService

  @conn ||= connect

  def self.clone(widget_id, dataset_id, api_key, user_id = nil)
    begin
      Rails.logger.info 'Cloning Widget in the API.'
      Rails.logger.info "Widget: #{widget_id}"

      user = { userId: user_id } if user_id.present?

      res = @conn.microservice_request(
          "/v1/dataset/#{dataset_id}/widget/#{widget_id}/clone",
          :post,
          { 'x-api-key': api_key },
          user)

      widget_id = JSON.parse(res)['data']['id']
    rescue RwApiMicroservice::NotFoundError
      Rails.logger.info "Widget #{widget_id} doesn't exist and can't be cloned"
    rescue => e
      Rails.logger.error "Error creating new widget in the API: #{e}"
      raise e.message
    end
    widget_id
  end
end
