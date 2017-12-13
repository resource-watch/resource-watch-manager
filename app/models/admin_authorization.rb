class AdminAuthorization < ActiveAdmin::AuthorizationAdapter

  def authorized?(action, subject = nil)
    if Thread.current[:user].present?
      user = JSON.parse(Thread.current[:user])

      user['role'] == 'ADMIN' && user['extraUserData']['apps'].include?('rw')
    else
      false
    end
  end

end