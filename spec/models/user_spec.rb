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
end
