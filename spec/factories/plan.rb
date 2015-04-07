FactoryGirl.define do
  factory :plan, class: 'PaidUp::Plan' do
    name 'Plan Name'
    description 'This is the description'
    charge 0.00
    period 'Month'
    cycles 1
    sort 0
  end
end