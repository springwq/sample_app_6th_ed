FactoryBot.define do
  FactoryBot.define do
    factory :user, class: User do
      name  { Faker::Name.name }
      email { Faker::Internet.email }
      password { 'password' }
    end
    factory :test_user, class: User do
      name  { Faker::Name.name }
      email { Faker::Internet.email }
      password { 'password' }
      activated { true }
      activated_at { Time.zone.now }
    end
  end
end
