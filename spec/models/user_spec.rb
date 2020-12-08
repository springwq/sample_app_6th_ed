require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(create(:user)).to be_valid
  end

  context 'when name is not present' do
    let(:user) {  User.new(email: Faker::Internet.email, password: User.digest('password')) }

    it 'should not be valid' do
      expect(user.valid?).to be false
    end

    it 'should not save' do
      expect(user.save).to be false
    end
  end

  describe '#send_password_reset_email' do
    let(:user) { User.new(name: 'test_name', password: 'test_password', email: 'test_email') }

    it 'should send email' do 
      allow(UserMailer).to receive_message_chain(:password_reset, :deliver_now)
      result = user.save
      expect(result).to be true
    end
  end

  describe "#validates" do

    context 'validates nil parmes' do 
      let(:user_nil_name) { User.new(name: '', password: 'test_password', email: 'test_email@test.com') }
      let(:user_nil_password) { User.new(name: 'test_user_name', password: '', email: 'test_email@test.com') }
      let(:user_nil_email) { User.new(name: 'test_user_name', password: 'test_password', email: '') }

      it 'should return false with nil name' do 
        result = user_nil_name.save
        expect(result).to be false
      end

      it 'should return false with nil password' do 
        result = user_nil_password.save
        expect(result).to be false
      end

      it 'should return false with nil email' do 
        result = user_nil_email.save
        expect(result).to be false
      end
    end

    context 'validates exists email' do 
      let!(:user) { create(:user, email: "test_email@126.com") }
      let(:new_user) { User.new(email: "test_email@126.com", password: SecureRandom.hex(4), name: SecureRandom.hex(3)) }
      it 'should return errors' do 
        result = new_user.save
        expect(result).to be false
      end
    end
  end

  describe '#feed' do
    let(:user_feed_test) { User.new(name: 'test_name', password: 'test_password', email: 'test_email@test.com') }

    it 'should return feed' do 
      expect(user_feed_test.feed.size).to equal(0)
    end
  end
end
