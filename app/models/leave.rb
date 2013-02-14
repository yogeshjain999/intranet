class Leave
  include Mongoid::Document
  belongs_to :user
  belongs_to :leave_type
  belongs_to :organization


  field :reason, type: String
  field :starts_at, type: Date
  field :ends_at, type: Date
  field :contact_address, type: String
  field :contact_number, type: Integer
  field :status, type: String
  field :reject_reason, type: String
  field :number_of_days, type: Float

  validates :reason, :starts_at, :ends_at, :contact_address, :contact_number, :leave_type_id, :presence => true
  validates :contact_number, :numericality => {:only_integer => true}
  validates :number_of_days, :numericality => true
  validate :validates_all

  def validates_all
    if !valid_date(starts_at)
      errors.add(:starts_at, "Invalid start date")
    elsif starts_at < Date.today
      errors.add(:starts_at, "Start date cannot be past")
    elsif starts_at > ends_at
      errors.add(:starts_at, "Start date cannot be grater than end date")
    end
    if !valid_date(ends_at)
      errors.add(:ends_at, "Invalid end date")
    elsif ends_at < starts_at
      errors.add(:ends_at, "End date should not be before start date")
    end
  end

  def valid_date(date)
    arr_date = date.to_s.split("/")
    if arr_date.length == 3
      if Date.valid_date?(arr_date[0].to_i, arr_date[1].to_i, arr_date[2].to_i)
        return true
      end
    end
    return false
  end

end
