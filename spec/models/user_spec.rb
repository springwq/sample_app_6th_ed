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
    let(:user) { User.new(email: Faker::Internet.email, password: SecureRandom.hex(4), name: Faker::Name.name) }

    it 'should send email' do 
      allow(UserMailer).to receive_message_chain(:password_reset, :deliver_now)
      result = user.save
      expect(result).to be true
    end

  end

  describe "#validates" do
    context 'validates nil name' do 
      let(:user) { User.new(email: Faker::Internet.email, password: SecureRandom.hex(4), name: "") }
      it 'should return errors' do 
        result = user.save
        expect(result).to be false
      end
    end

    context 'validates too long name' do 
      let(:user) { User.new(email: Faker::Internet.email, password: SecureRandom.hex(4), name: SecureRandom.hex(30)) }
      it 'should return errors' do 
        result = user.save
        expect(result).to be false
      end
    end

    context 'validates valid name' do 
      let(:user) { User.new(email: Faker::Internet.email, password: SecureRandom.hex(4), name: SecureRandom.hex(3)) }
      it 'should be success' do 
        result = user.save
        expect(result).to be true
      end
    end

    context 'validates invalid email' do 
      let(:user) { User.new(email: "test_email", password: SecureRandom.hex(4), name: SecureRandom.hex(3)) }
      it 'should return errors' do 
        result = user.save
        expect(result).to be false
      end
    end

    context 'validates nil email' do 
      let(:user) { User.new(email: "", password: SecureRandom.hex(4), name: SecureRandom.hex(3)) }
      it 'should return errors' do 
        result = user.save
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

  describe User do
    it {  should respond_to(:microposts) }
    it {  should respond_to(:active_relationships) }
    it {  should respond_to(:passive_relationships) }
    it {  should respond_to(:following) }
    it {  should respond_to(:followers) }
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
