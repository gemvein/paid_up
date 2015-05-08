shared_context 'subscribers' do
  include_context 'plans and features'
  include_context 'stripe'

  ############
  # Subscribers    #
  ############

  let!(:free_subscriber) {
    FactoryGirl.create(
      :subscriber,
      name: 'Free Subscriber'
    )
  }

  let!(:no_ads_subscriber) {
    FactoryGirl.create(
      :subscriber,
      name: 'No Ads Subscriber'
    )
  }

  let!(:group_leader_subscriber) {
    FactoryGirl.create(
      :subscriber,
      name: 'Group Leader Subscriber'
    )
  }

  let!(:professional_subscriber) {
    FactoryGirl.create(
      :subscriber,
      name: 'Professional Subscriber'
    )
  }

  let!(:no_ads_card_id) {
    no_ads_subscriber.subscribe_to_plan default_card_data, no_ads_plan
    no_ads_subscriber.cards.first.id
  }

  let!(:group_leader_card_id) {
    group_leader_subscriber.subscribe_to_plan default_card_data, group_leader_plan
    group_leader_subscriber.cards.first.id
  }

  let!(:professional_card_id) {
    professional_subscriber.subscribe_to_plan default_card_data, professional_plan
    professional_subscriber.cards.first.id
  }
end