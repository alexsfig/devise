FactoryGirl.define do
  factory :api_key do
    association :user
    api_key "DYuMyChIdIzZ_ebPBn7U5Q"
    name "mandrill"
    type_api "mail"
  end

end