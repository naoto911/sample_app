FactoryBot.define do
  factory :event do
    date              {Time.zone.local(2022, 1, 1)}
    place              {"test"}
    association :group
  end
end
