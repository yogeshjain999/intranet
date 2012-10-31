class Organization
  include Mongoid::Document
  include Mongoid::Slug

  field :name
  slug :name
  field :address1
  field :address2
  field :city
  field :country
  field :zip, type: Integer
  field :contact_number
  field :email

  has_many :users, dependent: :destroy

  validates :name, :address1, :city, :country, :zip, :contact_number, presence: true
  validates :name, uniqueness: true
  
  accepts_nested_attributes_for :users, allow_destory: true
end
