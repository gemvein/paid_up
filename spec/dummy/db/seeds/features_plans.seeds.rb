after :plans do
  ad_free = PaidUp::Feature.find_by_slug 'ad_free'
  groups = PaidUp::Feature.find_by_slug 'groups'
  doodads = PaidUp::Feature.find_by_slug 'doodads'

  free = PaidUp::Plan.find_by_name 'Free'
  no_ads = PaidUp::Plan.find_by_name 'No Ads'
  group_leader = PaidUp::Plan.find_by_name 'Group Leader'
  professional = PaidUp::Plan.find_by_name 'Professional'

  # Ad Free
  PaidUp::FeaturesPlan.create(
      feature: ad_free,
      plan: no_ads,
      setting: 1
  )

  # Group Leader
  PaidUp::FeaturesPlan.create(
      feature: ad_free,
      plan: group_leader,
      setting: 1
  )
  PaidUp::FeaturesPlan.create(
      feature: groups,
      plan: group_leader,
      setting: 1
  )
  PaidUp::FeaturesPlan.create(
      feature: doodads,
      plan: group_leader,
      setting: 5
  )

  # Professional
  PaidUp::FeaturesPlan.create(
      feature: ad_free,
      plan: professional,
      setting: 1
  )
  PaidUp::FeaturesPlan.create(
      feature: groups,
      plan: professional,
      setting: PaidUp::Unlimited.to_i(:db)
  )
  PaidUp::FeaturesPlan.create(
      feature: doodads,
      plan: professional,
      setting: PaidUp::Unlimited.to_i(:db)
  )
end