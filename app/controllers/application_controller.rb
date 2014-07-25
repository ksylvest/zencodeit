class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  helper_method :user
  helper_method :authenticated?

protected

  def user
    return @_user if @_user
    cookie = cookies.signed[:user]
    @_user = User.find(cookie) rescue deauthenticate if cookie
  end

  def authenticate(user)
    cookies.permanent.signed[:user] = user.id
    return
  end

  def deauthenticate
    cookies.delete :user
    return
  end

  def authenticated?
    user.present?
  end

  def authenticate!
    unless authenticated?
      store
      flash[:warning] = 'You must be logged in.'
      respond_to do |format|
        format.html { redirect_to new_session_path }
      end
      return false
    end
  end

  def store
    session[:location] = request.fullpath
  end

  def restore(options)
    location = session[:location] || options[:default]
    session[:location] = nil
    return location
  end

end
