FactoryGirl.define do
  factory :feature, class: 'PaidUp::Feature' do
    name 'Feature Name'
    description 'This is the description'
    setting_type 'boolean'
  end
end