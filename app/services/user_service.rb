class UserService < ApiService

  @conn ||= connect

  def self.users(user_ids= [])
    begin
      Rails.logger.info "Fetching user for id: #{user_ids.join(', ')}"


      res = @conn.microservice_request(
          "/auth/user/find-by-ids",
          :post,
          {},
          {
              ids: user_ids
          })

      widget_id = JSON.parse(res)['data']['id']
    rescue CtRegisterMicroservice::NotFoundError
      Rails.logger.info "User #{user_ids.inspect} doesn't exist and can't be cloned"
    rescue => e
      Rails.logger.error "Error fetching users from the API: #{e}"
    end
    widget_id
  end
end