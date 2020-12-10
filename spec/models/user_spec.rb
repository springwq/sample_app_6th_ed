require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(create(:user)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to have_many(:microposts).dependent(:destroy) }
    it { is_expected.to have_many(:active_relationships).with_foreign_key('follower_id').class_name('Relationship').dependent(:destroy)  }
    it { is_expected.to have_many(:passive_relationships).with_foreign_key('followed_id').class_name('Relationship').dependent(:destroy)  }
    it { is_expected.to have_many(:following).through(:active_relationships).source(:followed) }
    it { is_expected.to have_many(:followers).through(:passive_relationships).source(:follower) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name)}
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end
end
