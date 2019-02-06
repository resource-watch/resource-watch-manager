class WidgetService < ApiService

  @conn ||= connect

  def self.clone(widget_id, dataset_id)
    begin
      Rails.logger.info 'Cloning Widget in the API.'
      Rails.logger.info "Widget: #{widget_id}"

      res = @conn.microservice_request(
          "/v1/dataset/#{dataset_id}/widget/#{widget_id}/clone",
          :post)

      widget_id = JSON.parse(res)['data']['id']
    rescue CtRegisterMicroservice::NotFoundError
      Rails.logger.info "Widget #{widget_id} doesn't exist and can't be cloned"
    rescue => e
      Rails.logger.error "Error creating new widget in the API: #{e}"
      raise e.message
    end
    widget_id
  end
end