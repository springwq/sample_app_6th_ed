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
    let(:user) { User.new(email: "sylor@feedmob.com", password: "sylor12345",name: "sylor") }

    it 'should send email' do 
      allow(UserMailer).to receive_message_chain(:password_reset, :deliver_now)
      result = user.save
      expect(result).to be true
    end

  end

  describe '#feed' do
    let(:user) { create(:user) }

    it 'should return nil' do 
      expect(user.feed.size).to equal(0)
    end

    context "user create micopost" do
      let!(:user) { create(:user) }
      let!(:user_1) { create(:user) }
      let!(:user_2) { create(:user) }
      let!(:relationship) { create(:relationship, follower_id: user.id, followed_id: user_1.id) }
      let!(:micropost) { create(:micropost,user_id: user.id, content: "test" ) }
      let!(:micropost_1) { create(:micropost,user_id: user_1.id, content: "test1" ) }
      let!(:micropost_2) { create(:micropost,user_id: user_2.id, content: "test1" ) }

      it 'should get two feed' do 
        expect(user.feed.size).to equal(2)
      end

      it 'should get one feed' do 
        expect(user_2.feed.size).to equal(1)
      end
      
    end
  end
end
