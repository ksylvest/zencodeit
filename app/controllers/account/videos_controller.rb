class Account::VideosController < ApplicationController

  before_filter :authenticate!

  respond_to :html

  # GET /videos
  def index
    @user = user
    @videos = @user.videos

    respond_with(@videos)
  end

  # GET /account/videos/new
  def new
    @user = user
    @video = @user.videos.new

    respond_with(@video)
  end

  # GET /account/videos/1/edit
  def edit
    @user = user
    @video = @user.videos.find(params[:id])

    respond_with(@video)
  end

  # POST /account/videos
  def create
    @user = user
    @video = @user.videos.new
    @video.attributes = params.require(:video).permit(:name, :description, :encoding, :preview)
    @video.save

    respond_with(@video, notice: 'Video was successfully created.', location: account_videos_path)
  end

  # PUT /account/videos/1
  def update
    @user = user
    @video = @user.videos.find(params[:id])
    @video.attributes = params.require(:video).permit(:name, :description, :encoding, :preview)
    @video.save

    respond_with(@video, notice: 'Video was successfully updated.', location: account_videos_path)
  end

  # DELETE /account/videos/1
  def destroy
    @user = user
    @video = @user.videos.find(params[:id])
    @video.destroy

    respond_with(@video, notice: 'Video was successfully destroyed.', location: account_videos_path)
  end

end
