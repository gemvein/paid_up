FactoryGirl.define do
  factory :doodad do
    name 'Test Name'
    user { User.order('RANDOM()').first }
  end
end
