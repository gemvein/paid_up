require 'rails_helper'

describe PaidUp::FeaturesPlan do
  it { should belong_to(:plan).class_name("PaidUp::Plan") }
  it { should validate_presence_of(:setting) }
  it { should validate_presence_of(:plan) }
  it { should validate_presence_of(:feature) }
end