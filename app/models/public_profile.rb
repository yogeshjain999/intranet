class PublicProfile
  include Mongoid::Document
  mount_uploader :image, FileUploader 

  field :first_name, default: ''
  field :last_name, default: ''
  field :gender
  field :mobile_number
  field :blood_group
  field :date_of_birth, :type => Date
  field :skills
  field :github_handle
  field :twitter_handle
  field :blog_url
  field :image

  #validates_attachment :photo, :content_type => { :content_type => "image/jpg" }

  embedded_in :user
  
  #validates_presence_of :first_name, :last_name, :gender, :mobile_number, :date_of_birth, :blood_group, :on => :update
  validates :gender, inclusion: { in: GENDER }, allow_blank: true, :on => :update
  validates :blood_group, inclusion: { in: BLOOD_GROUPS }, allow_blank: true, :on => :update
  
  def name
    "#{first_name} #{last_name}"  
  end
end
