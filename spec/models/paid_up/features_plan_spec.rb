require 'rails_helper'

describe PaidUp::FeaturesPlan do
  it { should belong_to(:plan).class_name("PaidUp::Plan") }
  it { should belong_to(:feature).class_name("PaidUp::Feature") }
  it { should validate_presence_of(:setting) }
end