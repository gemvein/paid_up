require 'rails_helper'

describe PaidUp::Plan do
  include_context 'loaded site'

  it do
    should(
      have_many(:plan_feature_settings).class_name(
        'PaidUp::PlanFeatureSetting'
      )
    )
  end

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:stripe_id) }
  it { should validate_uniqueness_of(:title) }

  describe '.subscribable' do
    context 'returns all subscribable plans' do
      subject { PaidUp::Plan.subscribable }
      it do
        should eq [free_plan, no_ads_plan, group_leader_plan, professional_plan]
      end
    end
  end

  describe '.free' do
    context 'returns the free plan' do
      subject { PaidUp::Plan.free }
      it { should eq free_plan }
    end
  end

  describe '#feature_setting' do
    describe 'when setting_type is integer' do
      context 'returns the setting value if available' do
        subject { group_leader_plan.feature_setting('groups') }
        it { should eq(5) }
      end
      context 'returns 0 if not available' do
        subject { free_plan.feature_setting('groups') }
        it { should eq(0) }
      end
    end

    describe 'when setting_type is boolean' do
      context 'returns the setting value if available' do
        subject { group_leader_plan.feature_setting('ad_free') }
        it { should eq(true) }
      end
      context 'returns false if not available' do
        subject { free_plan.feature_setting('ad_free') }
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

  describe '#interval' do
    context 'on free plan' do
      subject { free_plan.interval }
      it { should eq 'month' }
    end
    context 'on a regular plan' do
      subject { no_ads_plan.interval }
      it { should eq 'month' }
    end
  end

  describe '#interval_count' do
    context 'on free plan' do
      subject { free_plan.interval_count }
      it { should eq 1 }
    end
    context 'on a regular plan' do
      subject { no_ads_plan.interval_count }
      it { should eq 1 }
    end
  end

  describe '#amount' do
    context 'on default plan' do
      subject { free_plan.amount }
      it { should eq 0 }
    end
    context 'on a regular plan' do
      subject { no_ads_plan.amount }
      it { should eq 100 }
    end
  end

  describe '#money' do
    context 'on default plan' do
      subject { free_plan.money }
      it { should be_a Money }
    end
    context 'on a regular plan' do
      subject { no_ads_plan.money }
      it { should be_a Money }
    end
  end

  describe '#charge' do
    context 'on default plan' do
      subject { free_plan.charge }
      it { should eq 0 }
    end
    context 'on a regular plan' do
      subject { no_ads_plan.charge }
      it { should eq 1 }
    end
  end

  describe '#currency' do
    context 'on default plan' do
      subject { free_plan.currency }
      it { should eq 'USD' }
    end
    context 'on a regular plan' do
      subject { no_ads_plan.currency }
      it { should eq 'USD' }
    end
  end
end
