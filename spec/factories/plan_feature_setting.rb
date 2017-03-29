# frozen_string_literal: true

FactoryGirl.define do
  factory :plan_feature_setting, class: 'PaidUp::PlanFeatureSetting' do
    feature nil
    plan nil
    setting 1
  end
end
