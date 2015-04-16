require 'rails_helper'

describe User do
  it { should have_many(:subscriptions).class_name('PaidUp::Subscription') }
  it { should have_many(:plans).class_name('PaidUp::Plan').through(:subscriptions) }
  it { should have_many(:features_plans).class_name('PaidUp::FeaturesPlan').through(:plans) }
  it { should have_many(:features).class_name('PaidUp::Feature').through(:features_plans) }
end