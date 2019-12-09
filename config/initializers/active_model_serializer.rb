# frozen_string_literal: true

class CustomPaginationLinks < ActiveModelSerializers::Adapter::JsonApi
  def success_document
    res = super

    unless res[:links].nil?
      normalize_pagination_links(res[:links])

      # Only append pagination metadata if no data has been set yet
      if res[:meta].nil?
        res[:meta] = append_pagination_meta_info(@serializer.object)
      end
    end

    return res
  end

  private

  def append_pagination_meta_info(collection)
    {
      'total-pages': collection.total_pages,
      'total-items': collection.total_entries,
      size: collection.per_page,
    }
  end

  def normalize_pagination_links(links)
    links.each do |key, link|
      link = links[:self] if link.nil?

      links[key] = replace_dashboard_correct_url(replace_logged_user_query_param(link))
    end
  end

  def replace_logged_user_query_param(str)
    return str if str.nil?
    str.gsub(/loggedUser=[^&]*&/m, '')
  end

  def replace_dashboard_correct_url(str)
    return str if str.nil?
    str.gsub(/api\/dashboards/m, 'v1/dashboard')
  end
end

ActiveModelSerializers.config.adapter = CustomPaginationLinks
