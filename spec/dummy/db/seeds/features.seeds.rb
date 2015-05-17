PaidUp::Feature.create(
    name: 'ad-free',
    title: 'Ad Free',
    description: 'Are ads removed from the site with this plan?',
    setting_type: 'boolean'
)
PaidUp::Feature.create(
    name: 'groups',
    title: 'Groups',
    description: 'How many groups are allowed with this plan?',
    setting_type: 'table_rows'  # Enables table row counting that is enabled by a positive value
                                # for the PaidUp::FeaturesPlan.setting associated with this PaidUp::Feature
)
PaidUp::Feature.create(
    name: 'calendar',
    title: 'Calendar',
    description: 'Is an event calendar included with this plan?',
    setting_type: 'boolean'
)