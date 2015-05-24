require 'rails_helper'
require "cancan/matchers"

describe User do
  include_context 'subscribers'

  context '#stripe_data' do
    subject { no_ads_subscriber.stripe_data }
    it { should be_a Stripe::Customer }
  end

  context '#cards' do
    subject { professional_subscriber.cards.first }
    it { should be_a Stripe::Card }
  end

  context '#subscribe_to_plan' do
    context 'starting from no subscription' do
      before do
        token = working_stripe_token free_subscriber
        free_subscriber.subscribe_to_plan no_ads_plan, token
      end
      subject { free_subscriber.plan }
      it { should eq(no_ads_plan) }
    end

    context 'starting from lower subscription' do
      context 'with saved card' do
        before do
          no_ads_subscriber.subscribe_to_plan group_leader_plan
        end
        subject { no_ads_subscriber.plan }
        it { should eq(group_leader_plan) }
      end
      context 'with new token' do
        before do
          token = working_stripe_token no_ads_subscriber
          no_ads_subscriber.subscribe_to_plan group_leader_plan, token
        end
        subject { no_ads_subscriber.plan }
        it { should eq(group_leader_plan) }
      end
    end

    context '#subscribe_to_free_plan' do
      context 'starting from no subscription' do
        let(:test_user) {
          user = FactoryGirl.create(
            :user,
            name: 'Test User'
          )
          user.subscribe_to_free_plan
          user
        }
        subject { test_user.plan }
        it { should eq(free_plan) }
      end

      context 'starting from higher subscription' do
        before do
          professional_subscriber.subscribe_to_free_plan
        end
        subject { professional_subscriber.plan }
        it { should eq(free_plan) }
      end
    end
  end

  context '#plan' do
    context 'when using free plan' do
      subject { free_subscriber.plan }
      it { should eq free_plan }
    end
    context 'when subscribed to a plan' do
      subject { no_ads_subscriber.plan }
      it { should eq no_ads_plan }
    end
  end

  context '#table_rows_remaining' do
    context 'when using a plan without the feature' do
      subject { no_ads_subscriber.table_rows_remaining 'doodads' }
      it { should eq 0 }
    end
    context 'when subscribed to a plan with the feature limited' do
      subject { group_leader_subscriber.table_rows_remaining 'doodads' }
      it { should eq 5 }
    end
    context 'when subscribed to a plan with the feature unlimited' do
      subject { professional_subscriber.table_rows_remaining 'doodads' }
      it { should eq PaidUp::Unlimited.to_i }
    end
  end

  context '#table_rows_unlimited?' do
    context 'when using a plan without the feature' do
      subject { no_ads_subscriber.table_rows_unlimited? 'doodads' }
      it { should eq false }
    end
    context 'when subscribed to a plan with the feature limited' do
      subject { group_leader_subscriber.table_rows_unlimited? 'doodads' }
      it { should eq false }
    end
    context 'when subscribed to a plan with the feature unlimited' do
      subject { professional_subscriber.table_rows_unlimited? 'doodads' }
      it { should eq true }
    end
  end

  context '#table_rows_allowed' do
    context 'when using a plan without the feature' do
      subject { no_ads_subscriber.table_rows_allowed 'doodads' }
      it { should eq 0 }
    end
    context 'when subscribed to a plan with the feature limited' do
      subject { group_leader_subscriber.table_rows_allowed 'doodads' }
      it { should eq 5 }
    end
    context 'when subscribed to a plan with the feature unlimited' do
      subject { professional_subscriber.table_rows_allowed 'doodads' }
      it { should eq PaidUp::Unlimited.to_i }
    end
  end

  context '#table_rows' do
    context 'when possessing no rows' do
      subject { professional_subscriber.table_rows 'doodads' }
      it { should eq 0 }
    end
    context 'when possessing 3 rows' do
      before do
        3.times do
          professional_subscriber.doodads.create! name: 'Test Doodad'
        end
      end
      subject { professional_subscriber.table_rows 'doodads' }
      it { should eq 3 }
    end
  end

  context '#rolify_rows_remaining' do
    context 'when using a plan without the feature' do
      subject { no_ads_subscriber.rolify_rows_remaining 'groups' }
      it { should eq 0 }
    end
    context 'when subscribed to a plan with the feature limited' do
      subject { group_leader_subscriber.rolify_rows_remaining 'groups' }
      it { should eq 1 }
    end
    context 'when subscribed to a plan with the feature unlimited' do
      subject { professional_subscriber.rolify_rows_remaining 'groups' }
      it { should eq PaidUp::Unlimited.to_i }
    end
  end

  context '#rolify_rows_unlimited?' do
    context 'when using a plan without the feature' do
      subject { no_ads_subscriber.rolify_rows_unlimited? 'groups' }
      it { should eq false }
    end
    context 'when subscribed to a plan with the feature limited' do
      subject { group_leader_subscriber.rolify_rows_unlimited? 'groups' }
      it { should eq false }
    end
    context 'when subscribed to a plan with the feature unlimited' do
      subject { professional_subscriber.rolify_rows_unlimited? 'groups' }
      it { should eq true }
    end
  end

  context '#rolify_rows_allowed' do
    context 'when using a plan without the feature' do
      subject { no_ads_subscriber.rolify_rows_allowed 'groups' }
      it { should eq 0 }
    end
    context 'when subscribed to a plan with the feature limited' do
      subject { group_leader_subscriber.rolify_rows_allowed 'groups' }
      it { should eq 1 }
    end
    context 'when subscribed to a plan with the feature unlimited' do
      subject { professional_subscriber.rolify_rows_allowed 'groups' }
      it { should eq PaidUp::Unlimited.to_i }
    end
  end

  context '#rolify_rows' do
    context 'when possessing no rows' do
      subject { professional_subscriber.rolify_rows 'groups' }
      it { should eq 0 }
    end
    context 'when possessing 3 rows' do
      before do
        3.times do
          group = Group.create! name: 'Test Group'
          professional_subscriber.add_role(:owner, group)
        end
      end
      subject { professional_subscriber.rolify_rows 'groups' }
      it { should eq 3 }
    end
  end

  context '#plan_stripe_id' do
    context 'when using free plan' do
      subject { free_subscriber.plan_stripe_id }
      it { should eq 'free-plan' }
    end
    context 'when subscribed to a plan' do
      subject { no_ads_subscriber.plan_stripe_id }
      it { should eq 'no-ads-plan' }
    end
  end

  context '#subscription' do
    context 'when using free plan' do
      subject { free_subscriber.subscription }
      it { should be_a Stripe::Subscription }
    end
    context 'when subscribed to a plan' do
      subject { no_ads_subscriber.subscription }
      it { should be_a Stripe::Subscription }
    end
  end

  context '#is_subscribed_to?' do
    context 'when using free plan' do
      subject { free_subscriber.is_subscribed_to? free_plan }
      it { should be true }
    end
    context 'when true' do
      subject { professional_subscriber.is_subscribed_to? professional_plan }
      it { should be true }
    end
    context 'when false' do
      subject { no_ads_subscriber.is_subscribed_to? professional_plan }
      it { should be false }
    end
  end

  context '#can_upgrade_to?' do
    context 'when using free plan' do
      context 'checking against free plan' do
        subject { free_subscriber.can_upgrade_to? free_plan }
        it { should be false }
      end
      context 'checking against another plan' do
        subject { free_subscriber.can_upgrade_to? no_ads_plan }
        it { should be true }
      end
    end
    context 'when true' do
      subject { no_ads_subscriber.can_upgrade_to? professional_plan }
      it { should be true }
    end
    context 'when false' do
      subject { professional_subscriber.can_upgrade_to? no_ads_plan }
      it { should be false }
    end
  end

  context '#can_downgrade_to?' do
    context 'when using free plan' do
      context 'checking against free plan' do
        subject { free_subscriber.can_downgrade_to? free_plan }
        it { should be false }
      end
      context 'checking against another plan' do
        subject { free_subscriber.can_downgrade_to? no_ads_plan }
        it { should be false }
      end
    end
    context 'when false' do
      subject { no_ads_subscriber.can_downgrade_to? professional_plan }
      it { should be false }
    end
    context 'when true' do
      subject { professional_subscriber.can_downgrade_to? no_ads_plan }
      it { should be true }
    end
  end

  context '#using_free_plan?' do
    context 'when false' do
      subject { no_ads_subscriber.using_free_plan?  }
      it { should be false }
    end
    context 'when true' do
      subject { free_subscriber.using_free_plan? }
      it { should be true }
    end
  end

  ####################
  # Abilities        #
  ####################


  describe "Abilities" do

    context "when anonymous" do
      let(:group) { Group.create!(name: 'Test Group') }
      let(:user){ nil }
      subject(:ability){ Ability.new(user) }
      it{ should be_able_to(:read, Group) }
      it{ should_not be_able_to(:manage, group) }
      it{ should_not be_able_to(:own, Group) }
      it{ should_not be_able_to(:create, Group) }
      it{ should_not be_able_to(:use, :ad_free) }
      it{ should_not be_able_to(:create, Doodad) }
    end
    context "when on free plan" do
      let(:group) { Group.create!(name: 'Test Group') }
      let(:user){ free_subscriber }
      subject(:ability){ Ability.new(user) }
      it{ should be_able_to(:read, Group) }
      it{ should_not be_able_to(:manage, group) }
      it{ should_not be_able_to(:own, Group) }
      it{ should_not be_able_to(:create, Group) }
      it{ should_not be_able_to(:use, :ad_free) }
      it{ should_not be_able_to(:create, Doodad) }
    end
    context "when on group plan" do
      context "given no groups are owned" do
        let(:group) { Group.create!(name: 'Test Group') }
        let(:user){ group_leader_subscriber }
        subject(:ability){ Ability.new(user) }
        it{ should be_able_to(:read, Group) }
        it{ should_not be_able_to(:manage, group) }
        it{ should be_able_to(:own, Group) }
        it{ should be_able_to(:create, Group) }
        it{ should be_able_to(:use, :ad_free) }
        it{ should be_able_to(:create, Doodad) }
      end
      context "given one group is owned" do
        let(:group) { Group.create!(name: 'Test Group') }
        let(:user) {
          group_leader_subscriber.add_role(:owner, group)
          group_leader_subscriber
        }
        subject(:ability){ Ability.new(user) }
        it{ should be_able_to(:read, Group) }
        it{ should be_able_to(:manage, group) }
        it{ should be_able_to(:own, Group) }
        it{ should_not be_able_to(:create, Group) }
        it{ should be_able_to(:use, :ad_free) }
        it{ should be_able_to(:create, Doodad) }
      end
    end
    context "when on professional plan" do
      context "given no groups are owned" do
        let(:group) { Group.create!(name: 'Test Group') }
        let(:user){ professional_subscriber }
        subject(:ability){ Ability.new(user) }
        it{ should be_able_to(:read, Group) }
        it{ should_not be_able_to(:manage, group) }
        it{ should be_able_to(:own, Group) }
        it{ should be_able_to(:create, Group) }
        it{ should be_able_to(:use, :ad_free) }
        it{ should be_able_to(:create, Doodad) }
      end
      context "given one group is owned" do
        let(:group){ Group.create!(name: 'Test Group') }
        let(:user){
          professional_subscriber.add_role(:owner, group)
          professional_subscriber
        }
        subject(:ability){ Ability.new(user) }
        it{ should be_able_to(:read, Group) }
        it{ should be_able_to(:manage, group) }
        it{ should be_able_to(:own, Group) }
        it{ should be_able_to(:create, Group) }
        it{ should be_able_to(:use, :ad_free) }
        it{ should be_able_to(:create, Doodad) }
      end
    end
  end
end