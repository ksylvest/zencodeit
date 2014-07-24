class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  helper_method :user
  helper_method :authenticate!
  helper_method :authenticated?

  private

  def user
    session[:user] ||= {}
    return unless session[:user][:id]
    @_user ||= User.find(session[:user][:id]) rescue session[:user][:id] = nil
  end

  def authenticated?
    user
  end

  def authenticate!
    unless authenticated?
      session[:location] = request.fullpath
      redirect_to new_session_path
      return false
    end
  end

  def restore(options)
    location = session[:location] || options[:default]
    session[:location] = nil
    return location
  end

end
