FactoryBot.define do
  factory :join do
    level              {1}

    association :group
    association :user
  end
end
