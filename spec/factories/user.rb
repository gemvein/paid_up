FactoryGirl.define do
  factory :user do
    email { "#{name.gsub(' ', '.').downcase}@example.com" }
    password "password"
    password_confirmation "password"
    transient do
      plan { PaidUp::Plan.order("RANDOM()").first }
    end
    # the after(:create) yields two values; the user instance itself and the
    # evaluator, which stores all values from the factory, including transient
    # attributes; `create_list`'s second argument is the number of records
    # to create and we make sure the user is associated properly to the post
    after(:create) do |user, evaluator|
      token = Stripe::Token.create(
          card: {
              number: '4242424242424242',
              exp_month: 1,
              exp_year: 45,
              cvc: '111'
          }
      ).id
      user.subscribe_to_plan(evaluator.plan, token)
    end
  end
end