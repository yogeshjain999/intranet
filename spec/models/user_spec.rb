require 'spec_helper'

describe User do  

  it { should have_fields(:email, :encrypted_password, :role, :uid, :provider, :status) }
  it { should have_field(:status).of_type(String).with_default_value_of(STATUS[0]) }
  it { should embed_one :public_profile }
  it { should embed_one :private_profile }
  it { should accept_nested_attributes_for(:public_profile) }
  it { should accept_nested_attributes_for(:private_profile) }
  it { should validate_presence_of(:role) }
  it { should validate_presence_of(:email) }
  
  context "When inviting new user" do
    it "user can invite new user if he is admin" do
      user = FactoryGirl.create(:user, role: "Admin")
      ability = Ability.new(user)
      assert ability.can?(:invite_user, user)
    end

    it "user cannot invite new user if he is not admin" do
      user = FactoryGirl.create(:user, role: "Employee")
      ability = Ability.new(user)
      assert ability.cannot?(:invite_user, user)
    end

    it 'admin can manage user' do
      user = FactoryGirl.create(:user, role: "HR")
      ability = Ability.new(user)
      assert ability.can?(:edit, User)
    end
  end

  context "admin can manage project" do
    it "can manage project" do
      user = FactoryGirl.create(:user, role: "Admin")
      ability = Ability.new(user)
      assert ability.can?(:manage, Project)
    end
  end

  context "HR abilities" do
    it "HR abilities for user" do
      user = FactoryGirl.create(:user, role: "HR")
      ability = Ability.new(user)
      assert ability.can?(:edit, User)
      assert ability.can?(:public_profile, User)
      assert ability.can?(:private_profile, User)
      assert ability.can?(:invite_user, User)
    end
  end

  context "Employee abilities" do
    it "employee abilities fo user" do
      user = FactoryGirl.create(:user, role: "Employee")
      ability = Ability.new(user)
      assert ability.can?(:public_profile, User)
      assert ability.can?(:private_profile, User)
      assert ability.cannot?(:edit, User)
      assert ability.cannot?(:manage, Project)
    end
  end
  
  context "Intern abilities" do
    it "Intern abilities fo user" do
      user = FactoryGirl.create(:user, role: "Intern")
      ability = Ability.new(user)
      assert ability.can?(:public_profile, User)
      assert ability.can?(:private_profile, User)
      assert ability.cannot?(:edit, User)
      assert ability.cannot?(:manage, Project)
    end
  end
  
  context "Finance abilities" do
    it "Finance abilities fo user" do
      user = FactoryGirl.create(:user, role: "Finance")
      ability = Ability.new(user)
      assert ability.can?(:public_profile, User)
      assert ability.can?(:private_profile, User)
      assert ability.can?(:edit, User)
      assert ability.cannot?(:manage, Project)
    end
  end
end
