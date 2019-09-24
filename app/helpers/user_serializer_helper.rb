module UserSerializerHelper
  def self.list(elements, users)
    elements.map { |el| element(el, users) }.reduce([], :<<)
  end

  def self.element(element, users)
    hash = element.as_json
    user_id = hash.delete('user_id')
    user = users.select{ |u| u['_id'] == user_id }.first rescue nil
    element.class.module_eval { attr_accessor :user }
    element.user = user_serializer(user)
    element
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