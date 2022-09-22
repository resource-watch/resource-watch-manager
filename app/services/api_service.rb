class ApiService
  def self.connect
    RwApiMicroservice::Gateway.new
  end
end
