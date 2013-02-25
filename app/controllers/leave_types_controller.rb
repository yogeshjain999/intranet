class LeaveTypesController < ApplicationController
before_filter :current_organization
  load_and_authorize_resource
  # GET /leave_types
  # GET /leave_types.json
  def index
    @leave_types = current_organization.leave_types.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @leave_types }
    end
  end

  # GET /leave_types/new
  # GET /leave_types/new.json
  def new
    @leave_type = LeaveType.new
  end

  # GET /leave_types/1/edit
  def edit
    @leave_type = LeaveType.find(params[:id])
  end

  # POST /leave_types
  # POST /leave_types.json
  def create
    @leave_type = LeaveType.new(params[:leave_type])
    @leave_type.organization = current_organization
    respond_to do |format|
      if @leave_type.save
        format.html { redirect_to leave_types_path, notice: 'Leave type was successfully created.' }
        format.json { render json: @leave_type, status: :created, location: @leave_type }
      else
        format.html { render action: "new" }
        format.json { render json: @leave_type.errors, status: :unprocessable_entity }
        p @leave_type.errors
      end
    end
  end

  # PUT /leave_types/1
  # PUT /leave_types/1.json
  def update
    @leave_type = LeaveType.find(params[:id])

    respond_to do |format|
      if @leave_type.update_attributes(params[:leave_type])
        format.html { redirect_to leave_types_path, notice: 'Leave type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @leave_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leave_types/1
  # DELETE /leave_types/1.json
  def destroy
    @leave_type = LeaveType.find(params[:id])
    @leave_type.destroy

    respond_to do |format|
      format.html { redirect_to leave_types_url }
      format.json { head :no_content }
    end
  end
end
