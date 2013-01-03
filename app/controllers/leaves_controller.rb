class LeavesController < ApplicationController

  def index
    @leave = Leave.all

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @leave }
    end
  end

  def show
    @leave = Leave.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @leave }
    end
  end

 def new
  @leave = Leave.new
 end

 def create
  @leave = Leave.new(params[:leave])
  @leave.number_of_days = (@leave.ends_at - @leave.starts_at).to_i
  @leave.status = "Pending"
  respond_to do |format|
   if @leave.save
    format.html {redirect_to root_url, notice: 'Your request has been noted'}
    format.json {render json: @leave, status: :created}
   end
  end
 end

  def edit
    @leave = Leave.find(params[:id])
  end

  def update
    @leave = Leave.find(params[:id])

    respond_to do |format|
      if @leave.update_attributes(params[:leave])
        format.html { redirect_to @leave, notice: 'Leave is successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @leave.errors, status: :unprocessable_entity }
      end
    end
  end



end
