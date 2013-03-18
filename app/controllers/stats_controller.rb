class StatsController < ApplicationController
  def index
    @stats = Stats.all
  end

  def show
    @stats = Stats.find(params[:id])
  end

  def new
    @stats = Stats.new
  end

  def create
    @stats = Stats.new(params[:stats])
    if @stats.save
      redirect_to @stats, :notice => "Successfully created stats."
    else
      render :action => 'new'
    end
  end

  def edit
    @stats = Stats.find(params[:id])
  end

  def update
    @stats = Stats.find(params[:id])
    if @stats.update_attributes(params[:stats])
      redirect_to @stats, :notice  => "Successfully updated stats."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @stats = Stats.find(params[:id])
    @stats.destroy
    redirect_to stats_url, :notice => "Successfully destroyed stats."
  end
end
