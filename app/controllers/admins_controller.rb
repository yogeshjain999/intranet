class AdminsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource :class => false
  respond_to :json

  def contacts_from_site
    add_to_google_spreadsheet  
  end
  
  def add_to_google_spreadsheet
    begin
      session = GoogleDrive.login(JOSH_INFO_EMAIL, JOSH_INFO_PASSWORD)
      spreadsheet = session.file_by_title(GOOGLE_DRIVE_SHEET)
      worksheet = spreadsheet.worksheets[0]
      @contact_list = worksheet.rows[1..-1].collect{|row| { name: row[0].titleize,
          email: row[1],
          phone_number:row[3],
          date: row[7].to_date,
          message:row[6],
        }}.sort {|rec1, rec2| rec2[:date] <=> rec1[:date] }
    rescue
      flash[:error] = 'Gmail authentication failed.'
      redirect_to root_path
    end
  end


end
