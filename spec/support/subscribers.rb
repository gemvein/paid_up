shared_context 'subscribers' do
  include_context 'plans and features'

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

  before(:each) do
    no_ads_subscriber.subscribe_to_plan no_ads_plan
    group_leader_subscriber.subscribe_to_plan group_leader_plan
    professional_subscriber.subscribe_to_plan professional_plan
  end
end