# frozen_string_literal: true

class CustomPaginationLinks < ActiveModelSerializers::Adapter::JsonApi
  def success_document
    res = super

    if res[:links]
      normalize_pagination_links(res[:links])
    end

    return res
  end

  private

  def normalize_pagination_links(links)
    links[:self] = replace_dashboard_correct_url(replace_logged_user_query_param(links[:self]))
    links[:first] = replace_dashboard_correct_url(replace_logged_user_query_param(links[:first]))
    links[:last] = replace_dashboard_correct_url(replace_logged_user_query_param(links[:last]))
    links[:prev] = replace_dashboard_correct_url(replace_logged_user_query_param(links[:prev]))
    links[:next] = replace_dashboard_correct_url(replace_logged_user_query_param(links[:next]))
  end

  def replace_logged_user_query_param(str)
    return !str.nil? ? str.gsub(/loggedUser=[^&]*&/m, '') : str
  end

  def replace_dashboard_correct_url(str)
    return !str.nil? ? str.gsub(/api\/dashboards/m, 'v1/dashboard') : str
  end
end

ActiveModelSerializers.config.adapter = CustomPaginationLinks
