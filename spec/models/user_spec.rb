require 'rails_helper'

describe User do
  it { should have_one(:subscription).class_name('PaidUp::Subscription') }
  it { should have_one(:plan).class_name('PaidUp::Plan').through(:subscription) }
  it { should have_many(:features_plans).class_name('PaidUp::FeaturesPlan').through(:plan) }
  it { should have_many(:features).class_name('PaidUp::Feature').through(:features_plans) }

  # TODO missing remaining mixin methods
end