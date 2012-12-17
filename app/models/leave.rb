class Leave
  include Mongoid::Document

  belongs_to :user
  has_one :leave_type

  field :reason
  field :starts_at, type: Date
  field :ends_at, type: Date
  field :contact_address

  field :number_of_days, type: Integer # should not be visible to user, Only for Internal Usage
end
