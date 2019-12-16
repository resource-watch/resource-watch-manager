module PaginationHelper
  def self.get_self_link(collection, query)
    self_query = query.clone
    self_query = query.except(:page).clone
    self_query['page[number]'] = collection.current_page
    self_query['page[size]'] = collection.per_page
    "#{ENV['LOCAL_URL']}/v1/dashboard?#{self_query.to_query}"
  end

  def self.get_prev_link(collection, query)
    current = collection.current_page
    prev_query = query.except(:page).clone
    prev_query['page[number]'] = current <= 1 ? 1 : current - 1
    prev_query['page[size]'] = collection.per_page
    "#{ENV['LOCAL_URL']}/v1/dashboard?#{prev_query.to_query}"
  end

  def self.get_next_link(collection, query)
    total = collection.total_pages
    current = collection.current_page
    next_query = query.except(:page).clone
    next_query['page[number]'] = current >= total ? total : current + 1
    next_query['page[size]'] = collection.per_page
    "#{ENV['LOCAL_URL']}/v1/dashboard?#{next_query.to_query}"
  end

  def self.get_first_link(collection, query)
    first_query = query.except(:page).clone
    first_query['page[number]'] = 1
    first_query['page[size]'] = collection.per_page
    "#{ENV['LOCAL_URL']}/v1/dashboard?#{first_query.to_query}"
  end

  def self.get_last_link(collection, query)
    last_query = query.except(:page).clone
    last_query['page[number]'] = collection.total_pages
    last_query['page[size]'] = collection.per_page
    "#{ENV['LOCAL_URL']}/v1/dashboard?#{last_query.to_query}"
  end

  def self.handmade_pagination_links(collection, params)
    query = params.except(:controller, :action, :format, :loggedUser, :user).clone.permit!
    {
      self: get_self_link(collection, query),
      prev: get_prev_link(collection, query),
      next: get_next_link(collection, query),
      first: get_first_link(collection, query),
      last: get_last_link(collection, query),
    }
  end
end
