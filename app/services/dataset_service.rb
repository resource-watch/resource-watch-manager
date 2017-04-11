class DatasetService

  @conn ||= Faraday.new(url: (ENV['RW_API_URL']).to_s) do |faraday|
    faraday.request  :url_encoded             # form-encode POST params
    faraday.response :logger, Rails.logger    # log requests to STDOUT
    faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  end


  # Gets all the existing datasets
  # This was changed in the new version of the API, and now it's paginated...
  # ... so this will get the first 10000 records
  # Params
  # ++status++ the status of the dataset
  def self.datasets(status = 'saved')
    dataset_request = @conn.get '/dataset',  'page[number]' => '1', 'page[size]' => '10000', \
      'status' => status, 'app' => 'forest-atlas,gfw', '_' => Time.now.to_f
    datasets_json = JSON.parse dataset_request.body
    datasets = []

    begin
      datasets_json['data'].each do |data|
        datasets.push data
      end
    rescue Exception => e
      # TODO All this methods should throw an exception caught in the controller...
      # ... to render a different page
      Rails.logger.error "::DatasetService.get_datasets: #{e}"
    end

    datasets
  end
end