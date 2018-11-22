class WidgetService < ApiService

  @conn ||= connect

  def self.clone(token, widget_id, dataset_id)
    begin
      Rails.logger.info 'Cloning Widget in the API.'
      Rails.logger.info "Widget: #{widget_id}"

      res = @conn.patch do |req|
        req.url "dataset/#{dataset_id}/widget/#{widget_id}/clone"
        req.headers['Authorization'] = "Bearer #{token}"
        req.headers['Content-Type'] = 'application/json'
      end

      raise JSON.parse(res.body)['errors'].first['detail'] unless res.status == 200

      Rails.logger.info "Response from widget creation endpoint: #{res.body}"
      widget_id = JSON.parse(res.body)['data']['id']
    rescue => e
      Rails.logger.error "Error creating new widget in the API: #{e}"
      raise e.message
    end
    widget_id
  end
end