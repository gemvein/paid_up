require 'rails_helper'

describe "SubscriptionFeatures" do
  it 'should return correct version string' do
    SubscriptionFeatures.version_string.should == "SubscriptionFeatures version #{SubscriptionFeatures::VERSION}"
  end
end
