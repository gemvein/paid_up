require 'rails_helper'

describe PaidUp::Plan do
  it { should have_many(:features_plans).class_name('PaidUp::FeaturesPlan') }
  it { should have_many(:features).class_name('PaidUp::Feature').through(:features_plans) }

  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:name) }

  include_context 'plans and features'

  describe '#feature_setting' do
    describe 'when setting_type is integer' do
      context 'returns the setting value if available' do
        subject { group_leader_plan.feature_setting('groups') }
        it { should eq(1) }
      end
      context 'returns 0 if not available' do
        subject { free_plan.feature_setting('groups') }
        it { should eq(0) }
      end
    end

    describe 'when setting_type is boolean' do
      context 'returns the setting value if available' do
        subject { group_leader_plan.feature_setting('configuration') }
        it { should eq(true) }
      end
      context 'returns false if not available' do
        subject { free_plan.feature_setting('configuration') }
        it { should eq(false) }
      end
    end
  end

  describe '#feature_unlimited?' do
    context 'returns true if unlimited' do
      subject { professional_plan.feature_unlimited?('groups') }
      it { should eq(true) }
    end
    context 'returns false if an integer' do
      subject { group_leader_plan.feature_unlimited?('groups') }
      it { should eq(false) }
    end
    context 'returns false if not found' do
      subject { free_plan.feature_unlimited?('groups') }
      it { should eq(false) }
    end
  end

  describe '#default' do
    context 'returns the default plan' do
      subject { PaidUp::Plan.default }
      it { should eq free_plan }
    end
  end

end