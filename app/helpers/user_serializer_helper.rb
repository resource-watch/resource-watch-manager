module UserSerializerHelper
  def self.list(elements, users, isAdmin = false)
    elements.map { |el| element(el, users, isAdmin) }.reduce([], :<<)
  end

  def self.element(element, users, isAdmin = false)
    hash = element.as_json
    user_id = hash.delete('user_id')
    user = users.select{ |u| u['_id'] == user_id }.first rescue nil
    element.class.module_eval { attr_accessor :user }
    element.user = user_serializer(user, isAdmin)
    element
  end

  private

  def self.user_serializer(user, isAdmin)
    return {} if user.blank?

    result = {
        name: user['name'],
        email: user['email'],
        photo: user['photo'],
    }

    result[:role] = user['role'] if isAdmin

    result
  end
end
