FactoryGirl.define do
  factory :plan, class: 'PaidUp::Plan' do
    name 'Plan Name'
    description 'This is the description'
    sort_order 0
  end
end