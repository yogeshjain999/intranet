class Project
  include Mongoid::Document
  field :name
  field :code_climate_id
  field :code_climate_snippet

  has_and_belongs_to_many :users
  accepts_nested_attributes_for :users
  validates_presence_of :name
end
