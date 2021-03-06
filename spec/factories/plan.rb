# frozen_string_literal: true

FactoryBot.define do
  factory :plan, class: 'PaidUp::Plan' do
    title { 'Plan Title' }
    description { 'This is the description' }
    sort_order { 0 }
  end
end
