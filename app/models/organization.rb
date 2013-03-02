class Organization
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Paperclip 
  has_mongoid_attached_file :csv_attachment
  attr_accessible :csv_attachment, :name, :address1, :address2, :city, :country, :zip, :contact_number, :users_attributes

  field :name
  slug :name
  field :address1
  field :address2
  field :city
  field :country
  field :zip, type: Integer
  field :contact_number, type: Integer

  has_many :users, dependent: :destroy
  has_many :leave_types, dependent: :destroy
  has_many :leaves, class_name: "Leave", dependent: :destroy
  accepts_nested_attributes_for :leave_types
  validates :name, :address1, :city, :country, :zip, :contact_number, presence: true
  validates :contact_number, :zip, :numericality => {:only_integer => true}
  validates :name, uniqueness: true
  validates_attachment :csv_attachment, content_type:  {:content_type => ['text/csv', 'application/vnd.ms-excel']}
  accepts_nested_attributes_for :users, allow_destroy: true
end
