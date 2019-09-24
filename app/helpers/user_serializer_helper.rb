module UserSerializerHelper
  def self.list(elements, users)
    elements.map { |el| element(el, users) }.reduce([], :<<)
  end

  def self.element(element, users)
    Rails.logger.info "[USH#element1]Params. Elem: #{element.inspect}. Users: #{users.inspect}"
    user = users.select{ |u| u['_id'] == user_id }.first rescue nil
    Rails.logger.info "[USH#element2]User to serialize: #{user.inspect}"
    element.class.module_eval { attr_accessor :user }
    element.user = user_serializer(user)
    Rails.logger.info "[USH#element3]User serialized: #{element.user.inspect}"
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