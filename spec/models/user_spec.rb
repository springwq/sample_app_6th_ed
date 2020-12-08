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

  describe '#send_password_reset_email' do
    let(:user) { described_class.new(email: Faker::Internet.email, password: SecureRandom.hex(4), name: Faker::Name.name) }
    
    it 'save success' do
      allow(UserMailer).to receive_message_chain(:password_reset, :deliver_now)
      result = user.save
      expect(result).to be true
    end
  end

  describe "#validates" do
    context 'with validates nil name' do
      let(:user) { described_class.new(email: Faker::Internet.email, password: SecureRandom.hex(4), name: "") }

      it 'return errors' do
        result = user.save
        expect(result).to be false
      end
    end

    context 'with validates too long name' do
      let(:user) { described_class.new(email: Faker::Internet.email, password: SecureRandom.hex(4), name: SecureRandom.hex(30)) }

      it 'return errors' do
        result = user.save
        expect(result).to be false
      end
    end

    context 'with validates valid name' do
      let(:user) { described_class.new(email: Faker::Internet.email, password: SecureRandom.hex(4), name: SecureRandom.hex(3)) }

      it 'save to be success' do
        result = user.save
        expect(result).to be true
      end
    end

    context 'with validates invalid email' do
      let(:user) { described_class.new(email: "test_email", password: SecureRandom.hex(4), name: SecureRandom.hex(3)) }

      it 'return errors' do
        result = user.save
        expect(result).to be false
      end
    end

    context 'with validates nil email' do
      let(:user) { described_class.new(email: "", password: SecureRandom.hex(4), name: SecureRandom.hex(3)) }

      it 'return errors' do
        result = user.save
        expect(result).to be false
      end
    end

    context 'with validates exists email' do
      let!(:user) { create(:user, email: "test_email@126.com") }
      let(:new_user) { described_class.new(email: "test_email@126.com", password: SecureRandom.hex(4), name: SecureRandom.hex(3)) }

      it 'return errors' do
        result = new_user.save
        expect(result).to be false
      end
    end
  end

  describe User do
    it {  is_expected.to respond_to(:microposts) }
    it {  is_expected.to respond_to(:active_relationships) }
    it {  is_expected.to respond_to(:passive_relationships) }
    it {  is_expected.to respond_to(:following) }
    it {  is_expected.to respond_to(:followers) }
  end

  describe '#feed' do
    let(:user) { create(:user) }

    it 'return nil' do
      expect(user.feed.size).to equal(0)
    end

    context "when user create micopost" do
      let!(:user) { create(:user) }
      let!(:user_a) { create(:user) }
      let!(:user_b) { create(:user) }

      before do
        create(:relationship, follower_id: user.id, followed_id: user_a.id)
        create(:micropost, user_id: user.id, content: "test")
        create(:micropost, user_id: user_a.id, content: "test1")
        create(:micropost, user_id: user_b.id, content: "test1")
      end

      it 'get two feed' do
        expect(user.feed.size).to equal(2)
      end

      it 'get one feed' do
        expect(user_b.feed.size).to equal(1)
      end      
    end
  end
end
