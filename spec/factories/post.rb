FactoryGirl.define do
  factory :post do
    title 'Test Title'
    user { User.order('RANDOM()').first }
    active true
  end
end
