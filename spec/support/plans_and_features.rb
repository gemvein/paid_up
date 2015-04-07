shared_context "plans and features" do

  ############
  # Features #
  ############

  let!(:ad_free_feature) { FactoryGirl.create(
      :feature,
      name: 'ad-free',
      setting_type: 'boolean'
  ) }

  let!(:groups_feature) { FactoryGirl.create(
      :feature,
      name: 'groups',
      setting_type: 'integer'
  ) }

  let!(:configuration_feature) { FactoryGirl.create(
      :feature,
      name: 'configuration',
      setting_type: 'boolean'
  ) }

  let!(:theme_feature) { FactoryGirl.create(
      :feature,
      name: 'theme',
      setting_type: 'boolean'
  ) }

  let!(:calendar_feature) { FactoryGirl.create(
      :feature,
      name: 'calendar',
      setting_type: 'boolean'
  ) }

  #########
  # Plans #
  #########
  let!(:free_plan) {
    FactoryGirl.create(
      :plan,
      name: 'Free',
      charge: '0.00',
      sort: 0
    )
  }
  let!(:no_ads_plan) {
    FactoryGirl.create(
      :plan,
      name: 'No Ads',
      charge: '1.00',
      sort: 1
    )
  }
  let!(:ad_free_no_ads_features_plan) {
    FactoryGirl.create(
       :features_plan,
       plan_id: no_ads_plan.id,
       feature_id: ad_free_feature.id
    )
  }
  let!(:group_leader_plan) {
    FactoryGirl.create(
      :plan,
      name: 'Group Leader',
      charge: '5.00',
      sort: 2
    )
  }
  let!(:ad_free_group_leader_features_plan) {
    FactoryGirl.create(
        :features_plan,
        plan_id: group_leader_plan.id,
        feature_id: ad_free_feature.id,
        setting: true
    )
  }
  let!(:groups_group_leader_features_plan) {
    FactoryGirl.create(
        :features_plan,
        plan_id: group_leader_plan.id,
        feature_id: groups_feature.id,
        setting: 1
    )
  }
  let!(:configuration_group_leader_features_plan) {
    FactoryGirl.create(
        :features_plan,
        plan_id: group_leader_plan.id,
        feature_id: configuration_feature.id,
        setting: true
    )
  }
  let!(:professional_plan) {
    FactoryGirl.create(
      :plan,
      name: 'Professional',
      charge: '10.00',
      sort: 3
    )
  }
  let!(:ad_free_professional_features_plan) {
    FactoryGirl.create(
        :features_plan,
        plan_id: professional_plan.id,
        feature_id: ad_free_feature.id,
        setting: true
    )
  }
  let!(:groups_professional_features_plan) {
    FactoryGirl.create(
        :features_plan,
        plan_id: professional_plan.id,
        feature_id: groups_feature.id,
        setting: -1
    )
  }
  let!(:configuration_professional_features_plan) {
    FactoryGirl.create(
        :features_plan,
        plan_id: professional_plan.id,
        feature_id: configuration_feature.id,
        setting: true
    )
  }
  let!(:theme_professional_features_plan) {
    FactoryGirl.create(
        :features_plan,
        plan_id: professional_plan.id,
        feature_id: theme_feature.id,
        setting: true
    )
  }
  let!(:calendar_professional_features_plan) {
    FactoryGirl.create(
        :features_plan,
        plan_id: professional_plan.id,
        feature_id: calendar_feature.id,
        setting: true
    )
  }

end