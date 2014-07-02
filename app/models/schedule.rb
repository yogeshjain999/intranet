class Schedule
  include Mongoid::Document

  field :interview_date,           :type => Date
  field :interview_time,           :type => Time
  field :interview_type,           :type => String
  field :candidate_details,        :type => Hash
  field :public_profile,           :type => Hash
  field :summary,									 :type => String
  field :description,               :type => String

  mount_uploader :file, FileUploader
end
