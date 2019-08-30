module UserSerializerHelper
  def self.list(elements, users)
    elements.map { |el| element(el, users) }.reduce([], :<<)
  end

  def self.element(element, users)
    hash = element.as_json
    user_id = hash.delete('user_id')
    Rails.logger.info("<Element> users_id: #{user_id}")
    user = users.select{ |u| u['_id'] == user_id }.first rescue nil
    Rails.logger.info("<Element> user: #{user.inspect}")
    hash[:user] = user_serializer(user)
    hash
  end

  private

  def self.user_serializer(user)
    return {} if user.blank?

    {
        id: user['_id'],
        name: user['name'],
        role: user['role'],
        email: user['email'],
        apps: user.dig('extraUserData', 'apps')
    }
  end
end