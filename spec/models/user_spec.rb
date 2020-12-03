require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(create(:user)).to be_valid
  end

  describe 'associations' do
    it { should have_many(:microposts).dependent(:destroy) }
    it { should have_many(:active_relationships).with_foreign_key('follower_id').class_name('Relationship').dependent(:destroy)  }
    it { should have_many(:passive_relationships).with_foreign_key('followed_id').class_name('Relationship').dependent(:destroy)  }
    it { should have_many(:following).through(:active_relationships).source(:followed) }
    it { should have_many(:followers).through(:passive_relationships).source(:follower) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name)}
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  context 'when name is not present' do
    let(:user) {  User.new(email: Faker::Internet.email, password: User.digest('password')) }

    it 'should not be valid' do
      expect(user.valid?).to be false
    end

    it 'should not save' do
      expect(user.save).to be false
    end


    descibe '#feed' do
    end
  end




end
