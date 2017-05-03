class Favorite::JobsController < ApplicationController
  before_action :authenticate_user!

  def index
    @jobs = current_user.favorite_jobs.paginate(:page => params[:page], :per_page => 15)

  end
end
