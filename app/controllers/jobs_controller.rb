class JobsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy, :collect, :discollect]
  def index
    @jobs = case params[:order]
    when 'by_lower_bound'
      Job.published.order('wage_lower_bound DESC').paginate(:page => params[:page], :per_page => 15)
    when 'by_upper_bound'
      Job.published.order("wage_upper_bound DESC").paginate(:page => params[:page], :per_page => 15)
    else
      Job.published.recent.paginate(:page => params[:page], :per_page => 15)
    end

  end

  def show
    @job = Job.find(params[:id])
    if @job.is_hidden
      flash[:warning] = "This Job already archived"
      redirect_to root_path

    end

  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to jobs_path

  end

  def edit
    @job = Job.find(params[:id])

  end

  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)
      redirect_to jobs_path
    else
      render :edit

    end
  end

    def new
      @job = Job.new

    end

    def create
      @job = Job.new(job_params)
      if @job.save
        redirect_to jobs_path
      else
        render :new

      end

    end

    def collect
      @job = Job.find(params[:id])
      if !current_user.favorite?(@job)
        current_user.collect!(@job)
        flash[:notice] = "收藏成功"

      else
        flash[:warning] = "已经收藏过该工作"

      end
        redirect_to :back

    end

    def discollect
      @job = Job.find(params[:id])
      if current_user.favorite?(@job)
        current_user.discollect!(@job)
        flash[:alert] = "已取消收藏"

      else
        flash[:warning] = "无此收藏"

      end
        redirect_to :back
    end



  private

  def job_params
    params.require(:job).permit(:title, :description, :wage_lower_bound, :wage_upper_bound, :contact_email, :is_hidden)
  end
end
