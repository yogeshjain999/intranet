class LeaveDeatailsController < ApplicationController

  def index
    @leaveDeatail = LeaveDeatail.all

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @leaveDeatail }
    end
  end

  def show
    @leaveDeatail = LeaveDeatail.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @leaveDeatail }
    end
  end

 def new
  @leaveDeatail = LeaveDeatail.new
 end

 def create
  @leaveDeatail = LeaveDeatail.new(params[:leaveDeatail])
  respond_to do |format|
   if @leaveDeatail.save
    format.html {redirect_to root_url, notice: 'Your request has been noted'}
    format.json {render json: @leaveDeatail, status: :created}
   end
  end
 end

  def edit
    @leaveDeatail = LeaveDeatail.find(params[:id])
  end

  def update
    @leaveDeatail = LeaveDeatail.find(params[:id])

    respond_to do |format|
      if @leaveDeatail.update_attributes(params[:leaveDeatail])
        format.html { redirect_to @leaveDeatail, notice: 'Leaves are successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @leaveDeatail.errors, status: :unprocessable_entity }
      end
    end
  end

end
