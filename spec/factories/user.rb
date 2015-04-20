FactoryGirl.define do
  factory :user do
    email { "#{name.gsub(' ', '.').downcase}@example.com" }
    password "password"
    password_confirmation "password"

    factory :subscriber do
      after(:create) do |subscriber|
        subscriber.subscribe_to_plan subscriber.plan
      end
    end
  end
end