require 'rails_helper'
RSpec.describe ApplicationRecord, type: :model do
    it '#self' do
        expect(ApplicationRecord.abstract_class).to eq true
    end

end