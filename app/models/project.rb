class Project
  include Mongoid::Document
  include Mongoid::Slug
  field :name
  field :code_climate_id
  field :code_climate_snippet
  field :code_climate_coverage_snippet
  field :is_active, type: Boolean, default: true
  slug :name

  has_and_belongs_to_many :users
  accepts_nested_attributes_for :users
  validates_presence_of :name
  
  scope :all_active, ->{where(is_active: true).asc(:name)}

  def self.get_all_sorted_by_name
    Project.all.asc(:name)
  end
end
