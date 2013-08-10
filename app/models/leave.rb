
class Leave
  include Mongoid::Document
  belongs_to :user
  belongs_to :leave_type
  belongs_to :organization

  paginates_per 10

  field :reason, type: String
  field :starts_at, type: Date
  field :ends_at, type: Date
  field :contact_address, type: String
  field :contact_number, type: Integer
  field :status, type: String
  field :reject_reason, type: String
  field :number_of_days, type: Float

  validates :reason, :contact_address, :contact_number, :leave_type_id,  :presence => true
  validates :starts_at, :presence => true
  validates :ends_at, :presence => true
  validates :reject_reason, :presence => true, :if => :reject_reason_validation?
  validates :contact_number, :numericality => {:only_integer => true}
  validates :number_of_days, :numericality => true
  validate :validates_all

  def reject_reason_validation?
    status == "Rejected"
  end

  def access_params(params, available_leaves)
    @leave_params = params
    @available_leaves = available_leaves
  end

  def valid_date(date)
regexp = /\d{2}\/\d{2}\/\d{4}/
date = date.to_s
    if date.include?("/")
      arr_date = date.split("/")
    elsif date.include?("-")
            arr_date = date.split("-")
    end
    if regexp.match(date) != nil
      if arr_date != nil && arr_date.length == 3
        if Date.valid_date?(arr_date[2].to_i, arr_date[1].to_i, arr_date[0].to_i)
          return true
        end
      end
    end
    return false
  end

  def validates_all
    if @available_leaves == nil
      errors[:base] << "Leaves are not assigned for you. Please contact your administrator"
    else
      leave_type = nil
      if @leave_params != nil
        if @leave_params["leave_type_id"] != nil && @leave_params["leave_type_id"] != ""
          leave_type = LeaveType.find(@leave_params["leave_type_id"])
          if number_of_days != nil
            if leave_type.can_apply != nil
              if number_of_days > leave_type.can_apply
                errors.add(:number_of_days, "Number of leaves are more. You can apply for #{leave_type.can_apply}")
              end
            end
            number_days = @available_leaves[@leave_params[:leave_type_id]]
#            if number_of_days > number_days.to_f
#              errors.add(:number_of_days, "Leaves are more than available. Available leaves are #{@available_leaves[@leave_params["leave_type_id"]]}")
#            end
          end
        end
      end
      if starts_at != nil
        if valid_date(starts_at) != true
          errors.add(:starts_at, "Invalid start date")
        elsif ends_at != nil && starts_at > ends_at
          errors.add(:starts_at, "Start date cannot be greater than end date")
        end
      end
      if ends_at != nil
        if !valid_date(ends_at)
          errors.add(:ends_at, "Invalid end date")
        elsif starts_at != nil && ends_at < starts_at
          errors.add(:ends_at, "End date should not be before start date")
        end
      end
    end
  end

  def self.increment_leaves
    Organization.all.each do |organization|
      leave_types = organization.leave_types.where(:auto_increament => true)
      users = organization.users.ne(:roles => "Admin")
      leave_types.each do |lt|
        users.each do |u|
          u.leave_details.each do |l|
            if l.assign_date.year == Date.today.year
              l.assign_leaves[lt.id.to_s] = l.assign_leaves[lt.id.to_s].to_f + lt.number_of_leaves
              l.available_leaves[lt.id.to_s] = l.available_leaves[lt.id.to_s].to_f + lt.number_of_leaves
              l.save
            end
          end
        end
      end
    end
  end

end
