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
  # ++params++ a hash of parameters. The accepted parameters are:
  # - page[number]
  # - page[size]
  # - status
  # - app
  # - _
  # - ids
  def self.datasets(params = {})
    params = {} unless params.is_a? Hash
    params['page[number]'] ||= '1'
    params['page[size]'] ||= '10000'
    params['status'] ||= 'saved'
    params['app'] ||= 'rw,prep'
    params['_'] ||= Time.now.to_f
    params['includes'] ||= 'layer'
    params['vocabulary[frequency]'] ||= 'near_real-time'
    params['vocabulary[function]'] ||= 'planet_pulse'

    query_params = params.map { |k, v| "#{k}=#{v}" if !k.nil? && !v.nil? }
    query = '/dataset'
    query += "?#{query_params.join('&')}" unless query_params.nil?

    dataset_request = @conn.get query

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

  # Returns all the layers of a dataset
  # ++dataset_id++ the id of the dataset from which to get the layers
  def self.layers(dataset_id)
    layers_request = @conn.get "/dataset/#{id}/layers"
    layers_json = JSON.parse layers_request.body
    layers = []

    begin
      layers_json['data'].each do |data|
        layers.push data
      end
    rescue Exception => e
      Rails.logger.error "::DatasetService.get_layers: #{e}"
    end
    layers
  end
end
