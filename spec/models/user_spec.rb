require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  subject { user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  describe 'when email is not present' do
    before { user.email = '' }
    it { should_not be_valid }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    # it { should validate_uniqueness_of(:email) }
    # it { should validate_confirmation_of(:email) }
    it { should allow_value('example@domain.com').for(:email) }
  end

end
