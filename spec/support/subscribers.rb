shared_context 'subscribers' do
  include_context 'plans and features'
  include_context 'stripe'

  ############
  # Subscribers    #
  ############

  let(:free_subscriber) {
    subscriber = FactoryGirl.create(
      :subscriber,
      name: 'Free Subscriber'
    )
    subscriber.subscribe_to_free_plan
    subscriber
  }

  let(:no_ads_subscriber) {
    subscriber = FactoryGirl.create(
      :subscriber,
      name: 'No Ads Subscriber'
    )
    subscriber.subscribe_to_plan no_ads_plan, working_stripe_token(subscriber)
    subscriber
  }

  let(:group_leader_subscriber) {
    subscriber = FactoryGirl.create(
      :subscriber,
      name: 'Group Leader Subscriber'
    )
    subscriber.subscribe_to_plan group_leader_plan, working_stripe_token(subscriber)
    subscriber
  }

  let(:professional_subscriber) {
    subscriber = FactoryGirl.create(
      :subscriber,
      name: 'Professional Subscriber'
    )
    subscriber.subscribe_to_plan professional_plan, working_stripe_token(subscriber)
    subscriber
  }
end