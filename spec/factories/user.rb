FactoryGirl.define do
  factory :user, aliases: [:subscriber] do
    email { "#{name.gsub(' ', '.').downcase}@example.com" }
    password "password"
    password_confirmation "password"
  end
end