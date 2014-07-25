class SessionsController < ApplicationController

  # GET /session/new
  def new
    respond_to do |format|
      format.html
    end
  end

  # POST /session
  def create
    authenticate(User.omniauth(request.env['omniauth.auth']))
    flash[:notice] = 'Session successfully created.'

    respond_to do |format|
      format.html { redirect_to(restore(default: root_path)) }
    end
  end

  # DELETE /session
  def destroy
    deauthenticate
    flash[:notice] = 'Session successfully destroyed.'

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
