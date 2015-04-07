require 'rails_helper'

describe Plan do
  it { should have_many(:subscriptions) }
  it { should have_many(:subscribers).through(:subscriptions) }
  it { should have_many(:features_plans) }
  it { should have_many(:features).through(:features_plans) }

  it { should validate_presence_of(:charge) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:period) }
  it { should validate_presence_of(:cycles) }

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
end