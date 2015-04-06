require 'rails_helper'

describe FeaturesPlan do
  it { should belong_to(:plan) }
  it { should belong_to(:feature) }
end