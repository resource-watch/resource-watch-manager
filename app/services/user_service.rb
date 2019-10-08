class UserService < ApiService

  @conn ||= connect

  def self.users(user_ids= [])
    users = []
    begin
      Rails.logger.info "Fetching user for id: #{user_ids.join(', ')}"

      res = @conn.microservice_request(
          "/auth/user/find-by-ids",
          :post,
          {},
          {
              ids: user_ids
          })

      users = JSON.parse(res)['data']
    rescue CtRegisterMicroservice::NotFoundError
      Rails.logger.info "User #{user_ids.inspect} doesn't exist and can't be cloned"
    rescue => e
      Rails.logger.error "Error fetching users from the API: #{e}"
    end
    users
  end

  def self.usersByRole(role)
    users = []
    begin
      Rails.logger.info "Fetching user for role: #{role}"

      res = @conn.microservice_request(
        "/auth/user/ids/#{role}",
        :get
      )

      users = JSON.parse(res)['data']
    rescue CtRegisterMicroservice::NotFoundError
      Rails.logger.info "User by #{role} could not be retrieved"
    rescue => e
      Rails.logger.error "Error fetching users by role from the API: #{e}"
    end
    users
  end
end
