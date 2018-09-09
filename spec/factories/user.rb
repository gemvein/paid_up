# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "#{name.tr(' ', '.').downcase}#{n}@example.com"
    end
    password { 'password' }
    password_confirmation { 'password' }
    transient do
      plan { PaidUp::Plan.all.sample }
      past_due { false }
    end
    # the after(:create) yields two values; the user instance itself and the
    # evaluator, which stores all values from the factory, including transient
    # attributes; `create_list`'s second argument is the number of records
    # to create and we make sure the user is associated properly to the post
    after(:create) do |user, evaluator|
      if evaluator.past_due
        token = Stripe::Token.create(
          card: {
            number: '4000000000000341',
            exp_month: 1,
            exp_year: 45,
            cvc: '111'
          }
        ).id
        trial_end = 5.seconds.from_now.to_time.to_i
      else
        token = Stripe::Token.create(
          card: {
            number: '4242424242424242',
            exp_month: 1,
            exp_year: 45,
            cvc: '111'
          }
        ).id
        trial_end = nil
      end
      user.subscribe_to_plan(evaluator.plan, token, nil, trial_end)
    end
  end
end
