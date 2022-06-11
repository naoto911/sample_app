FactoryBot.define do
  factory :group do
    name              {"test"}
    introduction       {"test用のグループです"}
    adminuser_id              {1}
  end
end