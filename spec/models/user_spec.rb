# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

describe User do
  include_context 'loaded site'

  context '#stripe_data' do
    subject { no_ads_subscriber.stripe_data }
    it { should be_a Stripe::Customer }
  end

  context '#cards' do
    subject { prof_subscriber.cards.first }
    it { should be_a Stripe::Card }
  end

  context '#subscribe_to_plan' do
    context 'starting from no subscription' do
      before do
        token = working_stripe_token free_subscriber
        free_subscriber.subscribe_to_plan no_ads_plan, token
      end
      after do
        free_subscriber.subscribe_to_plan free_plan
      end
      subject { free_subscriber.plan }
      it { should eq(no_ads_plan) }
    end

    context 'starting from lower subscription' do
      context 'with saved card' do
        before do
          no_ads_subscriber.subscribe_to_plan group_leader_plan
        end
        after do
          no_ads_subscriber.subscribe_to_plan no_ads_plan
        end
        subject { no_ads_subscriber.plan }
        it { should eq(group_leader_plan) }
      end
      context 'with new token' do
        before do
          token = working_stripe_token no_ads_subscriber
          no_ads_subscriber.subscribe_to_plan group_leader_plan, token
        end
        after do
          no_ads_subscriber.subscribe_to_plan no_ads_plan
        end
        subject { no_ads_subscriber.plan }
        it { should eq(group_leader_plan) }
      end
    end

    context '#subscribe_to_free_plan' do
      context 'starting from no subscription' do
        let(:test_user) do
          user = FactoryGirl.create(
            :user,
            name: 'Test User'
          )
          user.subscribe_to_free_plan
          user
        end
        subject { test_user.plan }
        it { should eq(free_plan) }
      end

      context 'starting from higher subscription' do
        before do
          prof_subscriber.subscribe_to_free_plan
        end
        after do
          token = working_stripe_token no_ads_subscriber
          prof_subscriber.subscribe_to_plan professional_plan, token
        end
        subject { prof_subscriber.plan }
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

  context '#table_setting().rows_remaining' do
    context 'when using a plan without the feature' do
      subject { no_ads_subscriber.table_setting('doodads').rows_remaining }
      it { should eq 0 }
    end
    context 'when subscribed to a plan with the feature limited' do
      subject { leader_subscriber.table_setting('doodads').rows_remaining }
      it { should eq 10 }
    end
    context 'when subscribed to a plan with the feature unlimited' do
      subject { prof_subscriber.table_setting('doodads').rows_remaining }
      it { should eq PaidUp::Unlimited.to_i }
    end
  end

  context '#table_setting().rows_unlimited?' do
    context 'when using a plan without the feature' do
      subject { no_ads_subscriber.table_setting('doodads').rows_unlimited? }
      it { should eq false }
    end
    context 'when subscribed to a plan with the feature limited' do
      subject { leader_subscriber.table_setting('doodads').rows_unlimited? }
      it { should eq false }
    end
    context 'when subscribed to a plan with the feature unlimited' do
      subject { prof_subscriber.table_setting('doodads').rows_unlimited? }
      it { should eq true }
    end
  end

  context '#table_setting().rows_allowed' do
    context 'when using a plan without the feature' do
      subject { no_ads_subscriber.table_setting('doodads').rows_allowed }
      it { should eq 0 }
    end
    context 'when subscribed to a plan with the feature limited' do
      subject { leader_subscriber.table_setting('doodads').rows_allowed }
      it { should eq 10 }
    end
    context 'when subscribed to a plan with the feature unlimited' do
      subject { prof_subscriber.table_setting('doodads').rows_allowed }
      it { should eq PaidUp::Unlimited.to_i }
    end
  end

  context '#table_setting().rows_count' do
    context 'when possessing no rows' do
      subject { prof_subscriber.table_setting('doodads').rows_count }
      it { should eq 0 }
    end
    context 'when possessing 3 rows' do
      before do
        3.times do
          prof_subscriber.doodads.create! name: 'Test Doodad'
        end
      end
      subject { prof_subscriber.table_setting('doodads').rows_count }
      it { should eq 3 }
    end
  end

  context '#rolify_setting().rows_remaining' do
    context 'when using a plan without the feature' do
      subject { no_ads_subscriber.rolify_setting('groups').rows_remaining }
      it { should eq 0 }
    end
    context 'when subscribed to a plan with the feature limited' do
      subject { leader_subscriber.rolify_setting('groups').rows_remaining }
      it { should eq 4 }
    end
    context 'when subscribed to a plan with the feature unlimited' do
      subject { prof_subscriber.rolify_setting('groups').rows_remaining }
      it { should be > 99_999_999 }
    end
  end

  context '#rolify_setting().rows_unlimited?' do
    context 'when using a plan without the feature' do
      subject { no_ads_subscriber.rolify_setting('groups').rows_unlimited? }
      it { should eq false }
    end
    context 'when subscribed to a plan with the feature limited' do
      subject { leader_subscriber.rolify_setting('groups').rows_unlimited? }
      it { should eq false }
    end
    context 'when subscribed to a plan with the feature unlimited' do
      subject { prof_subscriber.rolify_setting('groups').rows_unlimited? }
      it { should eq true }
    end
  end

  context '#rolify_setting().rows_allowed' do
    context 'when using a plan without the feature' do
      subject { no_ads_subscriber.rolify_setting('groups').rows_allowed }
      it { should eq 0 }
    end
    context 'when subscribed to a plan with the feature limited' do
      subject { leader_subscriber.rolify_setting('groups').rows_allowed }
      it { should eq 5 }
    end
    context 'when subscribed to a plan with the feature unlimited' do
      subject { prof_subscriber.rolify_setting('groups').rows_allowed }
      it { should eq PaidUp::Unlimited.to_i }
    end
  end

  context '#rolify_setting().rows_count' do
    context 'when possessing no rows' do
      subject { blank_subscriber.rolify_setting('groups').rows_count }
      it { should eq 0 }
    end
    context 'when possessing 3 rows' do
      before do
        3.times do
          FactoryGirl.create(
            :group,
            owner: blank_subscriber,
            active: true
          )
        end
      end
      subject { blank_subscriber.rolify_setting('groups').rows_count }
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
      it { should be_a PaidUp::Subscription }
    end
    context 'when subscribed to a plan' do
      subject { no_ads_subscriber.subscription }
      it { should be_a PaidUp::Subscription }
    end
  end

  context '#subscribed_to?' do
    context 'when using free plan' do
      subject { free_subscriber.subscribed_to? free_plan }
      it { should be true }
    end
    context 'when true' do
      subject { prof_subscriber.subscribed_to? professional_plan }
      it { should be true }
    end
    context 'when false' do
      subject { no_ads_subscriber.subscribed_to? professional_plan }
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
      subject { prof_subscriber.can_upgrade_to? no_ads_plan }
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
      subject { prof_subscriber.can_downgrade_to? no_ads_plan }
      it { should be true }
    end
  end

  context '#using_free_plan?' do
    context 'when false' do
      subject { no_ads_subscriber.using_free_plan? }
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

  describe 'Abilities' do
    context 'when anonymous' do
      let(:group) do
        FactoryGirl.create(:group, owner: prof_subscriber)
      end
      let(:user) { nil }
      subject(:ability) { Ability.new(user) }
      it { should be_able_to(:index, group) }
      it { should be_able_to(:show, group) }
      it { should_not be_able_to(:manage, group) }
      it { should_not be_able_to(:own, Group) }
      it { should_not be_able_to(:create, Group) }
      it { should_not be_able_to(:use, :ad_free) }
      it { should_not be_able_to(:create, Doodad) }
    end
    context 'when on free plan' do
      let(:group) do
        FactoryGirl.create(:group, owner: prof_subscriber)
      end
      let(:user) { free_subscriber }
      subject(:ability) { Ability.new(user) }
      it { should be_able_to(:index, group) }
      it { should be_able_to(:show, group) }
      it { should_not be_able_to(:manage, group) }
      it { should_not be_able_to(:own, Group) }
      it { should_not be_able_to(:create, Group) }
      it { should_not be_able_to(:use, :ad_free) }
      it { should_not be_able_to(:create, Doodad) }
    end
    context 'when on group plan' do
      describe 'misc abilities' do
        let(:user) { leader_subscriber }
        subject(:ability) { Ability.new(user) }
        it { should be_able_to(:use, :ad_free) }
      end
      describe 'using groups' do
        context 'given no groups are owned' do
          let(:group) do
            FactoryGirl.create(:group, owner: leader_subscriber)
          end
          let(:user) { leader_subscriber }
          subject(:ability) { Ability.new(user) }
          it { should be_able_to(:index, group) }
          it { should be_able_to(:show, group) }
          it { should be_able_to(:manage, group) }
          it { should be_able_to(:own, Group) }
          it { should be_able_to(:create, Group) }
        end
        context 'given all allowed groups are owned' do
          let(:group) do
            FactoryGirl.create(:group, owner: disabling_subscriber)
          end
          let(:user) { disabling_subscriber }
          subject(:ability) { Ability.new(user) }
          it { should be_able_to(:index, group) }
          it { should be_able_to(:show, group) }
          it { should be_able_to(:manage, group) }
          it { should be_able_to(:own, Group) }
          it { should_not be_able_to(:create, Group) }
        end
      end
      describe 'using doodads' do
        context 'given no doodads are owned' do
          let(:doodad) do
            FactoryGirl.create(:doodad, user: leader_subscriber)
          end
          let(:user) { leader_subscriber }
          subject(:ability) { Ability.new(user) }
          it { should be_able_to(:index, doodad) }
          it { should be_able_to(:show, doodad) }
          it { should be_able_to(:manage, doodad) }
          it { should be_able_to(:own, Doodad) }
          it { should be_able_to(:create, Doodad) }
        end
        context 'given all allowed doodads are owned' do
          let(:doodad) do
            FactoryGirl.create(:doodad, user: disabling_subscriber)
          end
          let(:user) { disabling_subscriber }
          subject(:ability) { Ability.new(user) }
          it { should be_able_to(:index, doodad) }
          it { should be_able_to(:show, doodad) }
          it { should be_able_to(:manage, doodad) }
          it { should be_able_to(:own, Doodad) }
          it { should_not be_able_to(:create, Doodad) }
        end
      end
      describe 'using posts' do
        context 'given no posts are owned' do
          let(:post) do
            FactoryGirl.create(:post, user: leader_subscriber)
          end
          let(:user) { leader_subscriber }
          subject(:ability) { Ability.new(user) }
          it { should be_able_to(:index, post) }
          it { should be_able_to(:show, post) }
          it { should be_able_to(:manage, post) }
          it { should be_able_to(:own, Post) }
          it { should be_able_to(:create, Post) }
        end
        context 'given all allowed posts are owned' do
          let(:post) do
            FactoryGirl.create(:post, user: disabling_subscriber)
          end
          let(:user) { disabling_subscriber }
          subject(:ability) { Ability.new(user) }
          it { should be_able_to(:index, post) }
          it { should be_able_to(:show, post) }
          it { should be_able_to(:manage, post) }
          it { should be_able_to(:own, Post) }
          it { should_not be_able_to(:create, Post) }
        end
      end
    end
    context 'when on professional plan' do
      context 'given no groups are owned' do
        let(:group) do
          FactoryGirl.create(:group, owner: blank_subscriber)
        end
        let(:user) { prof_subscriber }
        subject(:ability) { Ability.new(user) }
        it { should be_able_to(:index, group) }
        it { should be_able_to(:show, group) }
        it { should_not be_able_to(:manage, group) }
        it { should be_able_to(:own, Group) }
        it { should be_able_to(:create, Group) }
        it { should be_able_to(:use, :ad_free) }
        it { should be_able_to(:create, Doodad) }
      end
      context 'given one group is owned' do
        let(:group) do
          FactoryGirl.create(:group, owner: prof_subscriber)
        end
        let(:user) { prof_subscriber }
        subject(:ability) { Ability.new(user) }
        it { should be_able_to(:index, group) }
        it { should be_able_to(:show, group) }
        it { should be_able_to(:manage, group) }
        it { should be_able_to(:own, Group) }
        it { should be_able_to(:create, Group) }
        it { should be_able_to(:use, :ad_free) }
        it { should be_able_to(:create, Doodad) }
      end
    end
  end
end
