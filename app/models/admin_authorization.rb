# frozen_string_literal: true

class AdminAuthorization < ActiveAdmin::AuthorizationAdapter
  def authorized?(_action, _subject = nil)
    if Thread.current[:user].present?
      user = JSON.parse(Thread.current[:user])

      user['role'] == 'ADMIN' && user['extraUserData']['apps'].include?('rw')
    else
      false
    end
  end
end
