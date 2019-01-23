class ApiService
  def self.connect
    CtRegisterMicroservice::ControlTower.new
  end
end