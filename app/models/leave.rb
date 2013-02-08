class Leave
  include Mongoid::Document
  belongs_to :user
  belongs_to :leave_type
  belongs_to :organization


  field :reason
  field :starts_at, type: Date
  field :ends_at, type: Date
  field :contact_address
  field :contact_number
  field :status, type: String
  field :reject_reason, type: String
  field :number_of_days, type: Integer # should not be visible to user, Only for Internal Usage

  validates :reason, :starts_at, :ends_at, :contact_address, :contact_number, :leave_type_id, :presence => true
  validates :contact_number, :numericality => {:only_integer => true}
end
