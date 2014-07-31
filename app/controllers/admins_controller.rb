class AdminsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource :class => false
  respond_to :json

  def contacts_from_site
    if request.post?
      get_date_range
      if flash[:error].blank?
        case params["commit"]
        when 'Apply'
        else # Export to CSV
        end
      end
    end
    add_to_google_spreadsheet  
  end

  def add_to_google_spreadsheet
    begin
      "https://docs.google.com/a/joshsoftware.com/spreadsheet/ccc?key=0AjEH-x1ZNFzzdEZFWlNwaF9WWEpEQUh2QVRrTkVqdnc&usp=drive_web#gid=0"
      session = GoogleDrive.login(JOSH_INFO_EMAIL, JOSH_INFO_PASSWORD)
      spreadsheet = session.file_by_title(GOOGLE_DRIVE_SHEET)
      worksheet = spreadsheet.worksheets[0]
      #@contact_list = WORKSHEET.rows[1..-1].collect{|row| 
      @contact_list = worksheet.rows[1..-1].collect{|row| 
        record = { name: row[0].titleize,
          email: row[1],
          phone_number:row[3],
          date: row[7].to_date.to_s,
          message:row[6],
        } 
        date = row[7].to_s.to_date if row[7].present?
        record if filter_by_date(date)
      }.compact.sort {|rec1, rec2| rec2[:date] <=> rec1[:date] }
    rescue
      flash[:error] = 'Gmail authentication failed.'
      redirect_to root_path
    end
  end

  private

  def filter_by_date(date)
    @start_date.nil? and @end_date.nil? and return true
    return (date.present? and date >= @start_date and date <= @end_date)
  end

  def get_date_range 
    begin
      @start_date = params['start_at'].to_date
      @end_date = params['end_at'].to_date
    rescue
      flash[:error] = 'Date is invalid'
      return
    end
    flash[:error] = "Start date can't be greater than end date"  if @start_date.present? and @end_date.present? and @start_date > @end_date
  end

end
