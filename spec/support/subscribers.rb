shared_context 'subscribers' do
  include_context 'plans and features'

  ############
  # Subscribers    #
  ############

  let!(:free_subscriber) {
    FactoryGirl.create(
      :subscriber,
      name: 'Free Subscriber',
      plan: free_plan
    )

  }

  let!(:no_ads_subscriber) {
    FactoryGirl.create(
      :subscriber,
      name: 'No Ads Subscriber',
      plan: no_ads_plan
    )
  }

  let!(:group_leader_subscriber) {
    FactoryGirl.create(
      :subscriber,
      name: 'Group Leader Subscriber',
      plan: group_leader_plan
    )
  }

  let!(:professional_subscriber) {
    FactoryGirl.create(
      :subscriber,
      name: 'Professional Subscriber',
      plan: professional_plan
    )
  }
end