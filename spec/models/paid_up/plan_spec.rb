require 'rails_helper'

describe PaidUp::Plan do
  it { should have_many(:features_plans).class_name('PaidUp::FeaturesPlan') }
  it { should have_many(:features).class_name('PaidUp::Feature').through(:features_plans) }
  it { should have_many(:subscriptions).class_name('PaidUp::Subscription') }
  it { should have_many(:subscribers).through(:subscriptions) }

  it { should validate_presence_of(:charge) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:period) }
  it { should validate_presence_of(:cycles) }

  include_context 'plans and features'

  describe '#free' do
    describe 'returns all free plans' do
      subject { PaidUp::Plan.free }
      it { should eq [free_plan] }
    end
  end

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

  describe '.valid_date_phrase' do
    context 'returns a verbal description of how long a subscription lasts' do
      subject { professional_plan.valid_date_phrase }
      it { should eq '1 Month from now' }
    end
  end

  describe '.valid_date' do
    context 'returns unixtime value of how long a subscription lasts' do
      subject { professional_plan.valid_date }
      it { should eq Chronic.parse('1 Month from now') }
    end
  end

  describe '#highest' do
    context 'returns the highest plan' do
      subject { PaidUp::Plan.highest }
      it { should eq professional_plan }
    end
  end

  describe '#default' do
    context 'returns the default plan' do
      subject { PaidUp::Plan.default }
      it { should eq free_plan }
    end
  end

end