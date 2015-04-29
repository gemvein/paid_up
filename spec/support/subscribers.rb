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

  let(:default_card_data) {
    {
        object: 'card',
        number: '4242424242424242',
        exp_month: '12',
        exp_year: '15',
        cvc: '111'
    }
  }

  before(:each) do
    no_ads_subscriber.subscribe_to_plan default_card_data, no_ads_plan
    group_leader_subscriber.subscribe_to_plan default_card_data, group_leader_plan
    professional_subscriber.subscribe_to_plan default_card_data, professional_plan
  end
end