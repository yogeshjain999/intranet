class Schedule
  include Mongoid::Document

  field :interview_date,           :type => Date
  field :interview_time,           :type => String
  field :interview_type,           :type => String
  field :candidate_details,        :type => Hash
  field :public_profile,           :type => Hash

  mount_uploader :file, FileUploader
  has_and_belongs_to_many :users
end
