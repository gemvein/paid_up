shared_context "plans and features" do
  include_context 'stripe'

  ############
  # Features #
  ############

  let!(:ad_free_feature) { PaidUp::Feature.find_by_slug('ad_free') }
  let!(:groups_feature) { PaidUp::Feature.find_by_slug('groups') }
  let!(:doodads_feature) { PaidUp::Feature.find_by_slug('doodads') }

  #########
  # Plans #
  #########
  let!(:anonymous_plan) {
    Stripe::Plan.find_or_create_by_id(
        'anonymous-plan',
        {
            :amount => 0,
            :interval => 'month',
            :name => 'Anonymous Plan',
            :currency => 'usd',
            :id => 'anonymous-plan'
        }
    )
    FactoryGirl.create(
        :plan,
        name: 'Anonymous',
        stripe_id: 'anonymous-plan',
        sort_order: -1
    ).reload
  }
  let!(:free_plan) {
    Stripe::Plan.find_or_create_by_id(
        'free-plan',
        {
            :amount => 0,
            :interval => 'month',
            :name => 'Free Plan',
            :currency => 'usd',
            :id => 'free-plan'
        }
    )
    FactoryGirl.create(
      :plan,
      name: 'Free',
      stripe_id: 'free-plan',
      sort_order: 0
    ).reload
  }
  let!(:no_ads_plan) {
    Stripe::Plan.find_or_create_by_id(
        'no-ads-plan',
        {
            :amount => 100,
            :interval => 'month',
            :name => 'No Ads Plan',
            :currency => 'usd',
            :id => 'no-ads-plan'
        }
    )
    FactoryGirl.create(
      :plan,
      name: 'No Ads',
      stripe_id: 'no-ads-plan',
      sort_order: 1
    ).reload
  }
  let!(:ad_free_no_ads_plan_feature_setting) {
    FactoryGirl.create(
       :plan_feature_setting,
       plan_id: no_ads_plan.id,
       feature: 'ad_free',
       setting: true
    )
  }
  let!(:group_leader_plan) {
    Stripe::Plan.find_or_create_by_id(
      'group-leader-plan',
        {
        :amount => 500,
        :interval => 'month',
        :name => 'Group Leader Plan',
        :currency => 'usd',
        :id => 'group-leader-plan'
      }
    )
    FactoryGirl.create(
      :plan,
      name: 'Group Leader',
      stripe_id: 'group-leader-plan',
      sort_order: 2
    ).reload
  }
  let!(:ad_free_group_leader_plan_feature_setting) {
    FactoryGirl.create(
        :plan_feature_setting,
        plan_id: group_leader_plan.id,
        feature: 'ad_free',
        setting: true
    )
  }
  let!(:groups_group_leader_plan_feature_setting) {
    FactoryGirl.create(
        :plan_feature_setting,
        plan_id: group_leader_plan.id,
        feature: 'groups',
        setting: 1
    )
  }
  let!(:doodads_group_leader_plan_feature_setting) {
    FactoryGirl.create(
        :plan_feature_setting,
        plan_id: group_leader_plan.id,
        feature: 'doodads',
        setting: 5
    )
  }
  let!(:professional_plan) {
    Stripe::Plan.find_or_create_by_id(
        'professional-plan',
        {
            :amount => 1000,
            :interval => 'month',
            :name => 'Professional Plan',
            :currency => 'usd',
            :id => 'professional-plan'
        }
    )
    FactoryGirl.create(
      :plan,
      name: 'Professional',
      description: 'This is the description of the Professional plan.',
      stripe_id: 'professional-plan',
      sort_order: 3
    ).reload
  }
  let!(:ad_free_professional_plan_feature_setting) {
    FactoryGirl.create(
        :plan_feature_setting,
        plan_id: professional_plan.id,
        feature: 'ad_free',
        setting: true
    )
  }
  let!(:groups_professional_plan_feature_setting) {
    FactoryGirl.create(
        :plan_feature_setting,
        plan_id: professional_plan.id,
        feature: 'groups',
        setting: PaidUp::Unlimited.to_i(:db)
    )
  }
  let!(:doodads_professional_plan_feature_setting) {
    FactoryGirl.create(
        :plan_feature_setting,
        plan_id: professional_plan.id,
        feature: 'doodads',
        setting: PaidUp::Unlimited.to_i(:db)
    )
  }

end