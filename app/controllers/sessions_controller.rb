class SessionsController < ApplicationController

  # GET /session/new
  def new
    respond_to do |format|
      format.html
    end
  end

  # POST /session
  def create
    auth = request.env['omniauth.auth']
    user = User.omniauth(auth)

    flash[:notice] = 'Session successfully created.'

    session[:user] ||= {}
    session[:user][:id] = user.id

    respond_to do |format|
      format.html { redirect_to(restore(default: root_path)) }
    end
  end

  # DELETE /session
  def destroy
    flash[:notice] = 'Session successfully destroyed.'

    session[:user] ||= {}
    session[:user][:id] = nil

    respond_to do |format|
      format.html { redirect_to(restore(default: root_path)) }
    end
  end

  def failure
    respond_to do |format|
      format.hmtl { redirect_to(restore(default: root_path)) }
    end
  end

end
