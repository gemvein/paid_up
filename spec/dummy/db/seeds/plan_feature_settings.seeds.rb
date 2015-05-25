after :plans do
  free = PaidUp::Plan.find_by_name 'Free'
  no_ads = PaidUp::Plan.find_by_name 'No Ads'
  group_leader = PaidUp::Plan.find_by_name 'Group Leader'
  professional = PaidUp::Plan.find_by_name 'Professional'

  # Ad Free
  PaidUp::PlanFeatureSetting.create(
      feature: 'ad_free',
      plan: no_ads,
      setting: 1
  )

  # Group Leader
  PaidUp::PlanFeatureSetting.create(
      feature: 'ad_free',
      plan: group_leader,
      setting: 1
  )
  PaidUp::PlanFeatureSetting.create(
      feature: 'groups',
      plan: group_leader,
      setting: 1
  )
  PaidUp::PlanFeatureSetting.create(
      feature: 'doodads',
      plan: group_leader,
      setting: 5
  )

  # Professional
  PaidUp::PlanFeatureSetting.create(
      feature: 'ad_free',
      plan: professional,
      setting: 1
  )
  PaidUp::PlanFeatureSetting.create(
      feature: 'groups',
      plan: professional,
      setting: PaidUp::Unlimited.to_i(:db)
  )
  PaidUp::PlanFeatureSetting.create(
      feature: 'doodads',
      plan: professional,
      setting: PaidUp::Unlimited.to_i(:db)
  )
end