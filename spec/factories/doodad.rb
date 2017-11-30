# frozen_string_literal: true

FactoryBot.define do
  factory :doodad do
    name 'Test Name'
    user { User.order('RANDOM()').first }
  end
end
