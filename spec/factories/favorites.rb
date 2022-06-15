FactoryBot.define do
  factory :favorite do
    association :group
    association :user
  end
end
