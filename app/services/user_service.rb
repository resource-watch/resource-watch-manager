class UserService < ApiService

  @conn ||= connect

  def self.users(user_ids = [], api_key)
    users = []
    begin
      Rails.logger.info "Fetching user for id: #{user_ids.join(', ')}"

      res = @conn.microservice_request(
        "/auth/user/find-by-ids",
        :post,
        { 'x-api-key': api_key },
        {
          ids: user_ids.sort
        })

      users = JSON.parse(res)['data']
    rescue RwApiMicroservice::NotFoundError
      Rails.logger.info "User #{user_ids.inspect} doesn't exist and can't be cloned"
    rescue => e
      Rails.logger.error "Error fetching users from the API: #{e}"
    end
    users
  end

  def self.usersByRole(role, api_key)
    users = []
    begin
      Rails.logger.info "Fetching user for role: #{role}"

      res = @conn.microservice_request(
        "/auth/user/ids/#{role}",
        :get,
        { 'x-api-key': api_key }
      )

      users = JSON.parse(res)['data']
    rescue RwApiMicroservice::NotFoundError
      Rails.logger.info "User by #{role} could not be retrieved"
    rescue => e
      Rails.logger.error "Error fetching users by role from the API: #{e}"
    end
    users
  end
end
