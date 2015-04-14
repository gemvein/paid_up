PaidUp::Feature.create(
    name: 'ad-free',
    description: 'Are ads removed from the site with this plan?',
    setting_type: 'boolean'
)
PaidUp::Feature.create(
    name: 'groups',
    description: 'How many groups are allowed with this plan?',
    setting_type: 'integer'
)
PaidUp::Feature.create(
    name: 'calendar',
    description: 'Is an event calendar included with this plan?',
    setting_type: 'boolean'
)