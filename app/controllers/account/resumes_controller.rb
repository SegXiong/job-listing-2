class Account::ResumesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @resumes = Resume.where(:user_id => @user).order("created_at DESC").paginate(:page => params[:page], :per_page => 15)

  end
end
