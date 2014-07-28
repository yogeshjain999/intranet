namespace :leave do
  desc "Monthly Paid Leave Update"

  task :pending_increament => :environment do
    #STEP 1: Get user
    #STEP 2: if ['Admin', 'Intern'].exclude?(self.role) GOTO STEP 3 else STEP 1(find next user)
    #STEP 3: Get leave detail -> history_tracks for 2014
    #STEP 4: Get last day of next month in eom_date
    #STEP 5: if user's joining_date is in eom_date.month and day of joining is > 15 GOTO STEP 4
    #STEP 6: Get all records created_at date eom_date in eom_tracks
    #STEP 7: if record not found increament CPL and TPL by 1.5 GOTO STEP 3
    #STEP 8: else set flag increamented = false and iterate eom_tracks in var track 
    #STEP 9: in track if CPL is increamented by 1.5 set flag increamented = true GOTO STEP 4
    #STEP 10: if no increament found increament CPL and TPL by 1.5

    User.approved.each do |user|
      p 'NEXT USER======================================='
      p "Email: #{user.email}"
      eom_date = Date.today.beginning_of_year.end_of_month.to_date
      leave_detail = user.leave_details.where(year:Date.today.year).first
      joining_date = user.private_profile.date_of_joining
      p "Joining date #{joining_date}"
      if joining_date.present? and ['Admin', 'Intern'].exclude?(user.role)
        until eom_date > Date.today.beginning_of_month
          if joining_date.year != Date.today.year or joining_date.month != eom_date.month or (joining_date.month == eom_date.month and joining_date.day <= 15)
            increamented = leave_detail.history_tracks.detect{|track| 
              track.created_at.to_date == eom_date and 
              track.modified['available_leave']["TotalPrivilege"].to_f - track.original['available_leave']["TotalPrivilege"].to_f == 1.5
            }
            p "Increament done in month #{eom_date.month} -> #{increamented.present?}"
            unless increamented.present?
              p 'Increamented'
              #leave_detail.available_leave["CurrentPrivilege"] = (leave_detail.available_leave["CurrentPrivilege"].to_d + 1.5).to_s
              #leave_detail.available_leave["TotalPrivilege"] =  (leave_detail.available_leave["TotalPrivilege"].to_d + 1.5).to_s
              #leave_detail.save
            end
          end
          eom_date = eom_date.next_month.end_of_month
          p '--------------------------------------'
        end

      end
    end

  end

  task :increment_paid => :environment do
    MonthlyPaidLeaveWorker.perform_async()
  end

  task :reset_leave_yearly => :environment do
    ResetLeaveYearlyWorker.perform_async()
  end

  task :initial_seed => :environment do
    require 'csv'
    CSV.foreach("#{Rails.root}/doc/leave_initial_seed.csv", :headers => true) do|csv| 
      user = User.where(email: csv["email id"]).first
      if user
        leave_detail = user.leave_details.find_or_initialize_by(year: Date.today.year) 
        leave_detail.available_leave["Sick"] = csv["Sick Leave"].to_i
        leave_detail.available_leave["Casual"] = csv["Casual Leave"].to_i
        leave_detail.available_leave["TotalPrivilege"] = csv["Paid Leave"].to_i
        leave_detail.available_leave["CurrentPaid"] = 0
        leave_detail.save
      end
    end
  end

  task :change_available_leave_column => :environment do
    LeaveDetail.all.each do|leave_detail|
      leave_detail.available_leave["CurrentPrivilege"] = leave_detail.available_leave["CurrentPaid"]
      leave_detail.available_leave["TotalPrivilege"] = leave_detail.available_leave["TotalPaid"]
      leave_detail.save
    end
  end

  task :split_date => :environment do
    User.all.each do |user|
      user.set_details("doj", user.private_profile.date_of_joining)
      user.set_details("dob", user.public_profile.date_of_birth)
    end
  end
end
