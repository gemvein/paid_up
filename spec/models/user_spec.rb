require 'rails_helper'

describe User do
  include_context 'subscribers'

  context '#stripe_data' do
    subject { no_ads_subscriber.stripe_data }
    it { should be_a Stripe::Customer }
  end

  context '#cards' do
    subject { no_ads_subscriber.cards.first }
    it { should be_a Stripe::Card }
  end

  context '#card_from_token' do
    subject {
      token = working_stripe_token no_ads_subscriber
      no_ads_subscriber.card_from_token token
    }
    it { should be_a Stripe::Card }
  end

  context '#subscribe_to_plan' do
    context 'starting from no subscription' do
      before do
        free_subscriber.subscribe_to_plan default_card_data, no_ads_plan
      end
      subject { free_subscriber.plan }
      it { should eq(no_ads_plan) }
    end

    context 'starting from lower subscription' do
      context 'with saved card' do
        before do
          no_ads_subscriber.subscribe_to_plan no_ads_card_id, group_leader_plan
        end
        subject { no_ads_subscriber.plan }
        it { should eq(group_leader_plan) }
      end
      context 'with new token' do
        before do
          token = working_stripe_token no_ads_subscriber
          no_ads_subscriber.subscribe_to_plan token, group_leader_plan
        end
        subject { no_ads_subscriber.plan }
        it { should eq(group_leader_plan) }
      end
    end


    context 'starting from higher subscription' do
      context 'with saved card' do
        before do
          professional_subscriber.subscribe_to_plan professional_card_id, no_ads_plan
        end
        subject { professional_subscriber.plan }
        it { should eq(no_ads_plan) }
      end
      context 'with new token' do
        before do
          token = working_stripe_token professional_subscriber
          professional_subscriber.subscribe_to_plan token, no_ads_plan
        end
        subject { professional_subscriber.plan }
        it { should eq(no_ads_plan) }
      end
    end

  end

  context '#update_card' do
    subject {
      token = working_stripe_token no_ads_subscriber
      no_ads_subscriber.update_card token
    }
    it { should be_a Stripe::Card }
  end

  context '#plan' do
    context 'when using default plan' do
      subject { free_subscriber.plan }
      it { should eq free_plan }
    end
    context 'when subscribed to a plan' do
      subject { no_ads_subscriber.plan }
      it { should eq no_ads_plan }
    end
  end

  context '#plan_stripe_id' do
    context 'when using default plan' do
      subject { free_subscriber.plan_stripe_id }
      it { should be nil }
    end
    context 'when subscribed to a plan' do
      subject { no_ads_subscriber.plan_stripe_id }
      it { should eq 'no-ads-plan' }
    end
  end

  context '#subscription' do
    context 'when using default plan' do
      subject { free_subscriber.subscription }
      it { should be nil }
    end
    context 'when subscribed to a plan' do
      subject { no_ads_subscriber.subscription }
      it { should be_a Stripe::Subscription }
    end
  end

  context '#is_subscribed_to?' do
    context 'when using default plan' do
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
    context 'when using default plan' do
      context 'checking against default plan' do
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
    context 'when using default plan' do
      context 'checking against default plan' do
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

  context '#using_default_plan?' do
    context 'when false' do
      subject { no_ads_subscriber.using_default_plan?  }
      it { should be false }
    end
    context 'when true' do
      subject { free_subscriber.using_default_plan? }
      it { should be true }
    end
  end
end