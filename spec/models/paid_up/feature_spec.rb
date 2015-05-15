require 'rails_helper'

describe PaidUp::Feature do
  it { should have_many(:features_plans).class_name('PaidUp::FeaturesPlan') }
  it { should have_many(:plans).class_name('PaidUp::Plan').through(:features_plans) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:setting_type) }
end