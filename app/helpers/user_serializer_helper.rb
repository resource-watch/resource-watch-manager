module UserSerializerHelper
  def self.list(elements, users)
    elements.map { |el| element(el, users) }.reduce([], :<<)
  end

  def self.element(element, users)
    hash = element.as_json
    user_id = hash.delete('user_id')
    user = users.select { |u| u['_id'] == user_id }
    hash[:user] = user_serializer(user)
    hash
  end

  private

  def self.user_serializer(user)
    return {} if user.blank?

    begin
      {
          id: user['_id'],
          name: user['name'],
          role: user['role'],
          email: user['email'],
          apps: user.dig('extraUserData', 'apps')
      }
    rescue
      puts "Error on user: #{user.inspect}"
      return {}
    end
  end
end