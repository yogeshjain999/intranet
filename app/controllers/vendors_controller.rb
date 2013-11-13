class VendorsController < ApplicationController
  load_and_authorize_resource 
  skip_load_and_authorize_resource :only => :create
  before_action :load_vendor, except: [:index, :new, :create]
  before_action :build_vendor_resource, only: :new

  def index
    @vendors = Vendor.all
  end

  def create
    @vendor = Vendor.new(safe_params)
    if @vendor.save
      redirect_to vendors_path
    else
      render :new
    end
  end

  def update
    if @vendor.update_attributes(safe_params)
     flash[:notice] = "Vendor updated Succesfully" 
     redirect_to vendors_path
    else
      flash[:alert] = "Vendor: #{@vendor.errors.full_messages.join(',')}" 
      render 'edit'
    end
  end

  def destroy
    if @vendor.destroy
     flash[:notice] = "Vendor deleted Succesfully" 
    else
     flash[:notice] = "Error in deleting vendor"
    end
     redirect_to vendors_path
  end

  private
  
  def safe_params
    params.require(:vendor).permit(:company, :category, contact_persons_attributes: [ :name, :phone_no, :email ], 
                                   address_attributes: [ :address, :city, :pin_code, :state, :landline_no ])     
  end

  def load_vendor
    @vendor = Vendor.find(params[:id])
  end

  def build_vendor_resource
    @vendor = Vendor.new
    @vendor.contact_persons.build if @vendor.contact_persons.empty?
    @vendor.build_address if @vendor.address.nil?
  end
end
