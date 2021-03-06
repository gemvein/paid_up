# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    title { 'Test Title' }
    transient do
      owner { User.order('RANDOM()').first }
    end
    # the after(:create) yields two values; the user instance itself and the
    # evaluator, which stores all values from the factory, including transient
    # attributes; `create_list`'s second argument is the number of records
    # to create and we make sure the user is associated properly to the post
    after(:create) do |group, evaluator|
      group.save_with_owner(evaluator.owner)
    end
  end
end
