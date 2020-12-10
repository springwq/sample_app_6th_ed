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

  describe "#validates" do
    
    context 'validates nil name' do 
      let(:user_nil_name) { User.new(name: '', password: 'test_password', email: 'test_email@test.com') }

      it 'should return false with nil name' do 
        result = user_nil_name.save
        expect(result).to be false
      end
    end
    
    context 'validates nil password' do 
      let(:user_nil_password) { User.new(name: 'test_user_name', password: '', email: 'test_email@test.com') }
      
      it 'should return false with nil password' do 
        result = user_nil_password.save
        expect(result).to be false
      end
    end

    context 'validates nil password' do 
      let(:user_nil_email) { User.new(name: 'test_user_name', password: 'test_password', email: '') }
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

  describe '#send_password_reset_email' do
    let(:user) { User.new(name: "circle", email: "circle@feedmob.com", password: "123456") }
    
    it "send password reset email" do
      allow(UserMailer).to receive(:password_reset)
      result = user.save
      expect(result).to eq(true)
    end
  end

  describe '#feed' do
    let!(:user) { create(:user) }
    context "where no feed" do
      
      it 'should equal 0' do 
        expect(user.feed.size).to eq(0)
      end
    end
    
    context "where 1 feed" do
      let!(:user_1) { create(:user) }
      let!(:micropost) { create(:micropost, user_id: user_1.id, content: "test1") }
      
      it "should equal 1" do
        expect(user_1.feed.size).to eq(1)
      end
    end
  end
end
