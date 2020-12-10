require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(create(:user)).to be_valid
  end

  context 'when name is not present' do
    let(:user) { described_class.new(email: Faker::Internet.email, password: described_class.digest('password')) }

    it 'is inivalid' do
      expect(user.valid?).to be false
    end

    it 'is failed to save' do
      expect(user.save).to be false
    end
  end

  describe "#validates" do

    context 'validates nil name' do 
      let(:user_nil_name) { User.new(name: 'test_name', password: 'test_password', email: 'test_email@test.com') }

      it 'should return false with nil name' do 
        result = user_nil_name.save
        expect(result).to be false
      end
    end
  end
end
