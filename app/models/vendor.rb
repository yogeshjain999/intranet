class Vendor
  include Mongoid::Document
  include Mongoid::Slug
  field :company, type: String
  field :category, type: String

  slug :company

  has_one :address
  embeds_many :contact_persons 
  
  accepts_nested_attributes_for :contact_persons, :address
  validates :company, :category, presence: true
end

