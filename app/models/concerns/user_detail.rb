module UserDetail
  extend ActiveSupport::Concern
  
  included do
    embeds_one :public_profile
    embeds_one :private_profile, cascade_callbacks: true
    embeds_one :employee_detail, cascade_callbacks: true
    
    accepts_nested_attributes_for :private_profile, reject_if: :all_blank, allow_destroy: true 
    accepts_nested_attributes_for :public_profile, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :employee_detail, reject_if: :all_blank, :allow_destroy => true
  end
  
  module ClassMethods    
    def from_omniauth(auth)
      if auth.info.email.include? "joshsoftware.com"
        user = User.where(email: auth.info.email).first
        create_public_profile_if_not_present(user, auth)
        user
      else
        false
      end
    end

    def create_public_profile_if_not_present(user, auth)
      if user && !user.public_profile?
        user.build_public_profile(first_name: auth.info.first_name, last_name: auth.info.last_name).save
        user.update_attributes(provider: auth.provider, uid: auth.uid)
      end
    end
  end

end 
