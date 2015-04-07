require 'rails_helper'

describe PaidUp::FeaturesPlan do
  it { should belong_to(:plan).class_name("PaidUp::Plan") }
  it { should belong_to(:feature).class_name("PaidUp::Feature") }
  it { should validate_presence_of(:setting) }

  include_context 'plans and features'

  describe '#unlimited?' do
    context 'returns true when plan has unlimited value' do
      subject { groups_professional_features_plan.unlimited? }
      it { should eq(true) }
    end
    context 'returns false when plan has an integer value' do
      subject { groups_group_leader_features_plan.unlimited? }
      it { should eq(false) }
    end
  end

  describe '.find_by_feature_name' do
    context 'returns features_plan when plan has feature' do
      subject { group_leader_plan.features_plans.find_by_feature_name('groups') }
      it { should be_a(PaidUp::FeaturesPlan) }
    end
    context 'returns nil when plan does not have feature' do
      subject { free_plan.features_plans.find_by_feature_name('groups') }
      it { should be(nil) }
    end
  end
end