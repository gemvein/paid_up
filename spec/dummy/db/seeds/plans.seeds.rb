PaidUp::Plan.create(
        name: 'Free',
        description: "Can't beat the price!",
        sort: 0
)
PaidUp::Plan.create(
    name: 'No Ads',
    stripe_id: 'no-ads-plan',
    description: "No frills, just removes the ads.",
    sort: 1
)
PaidUp::Plan.create(
    name: 'Group Leader',
    stripe_id: 'group-leader-plan',
    description: "For leaders of single groups, with log configuration.",
    sort: 2
)
PaidUp::Plan.create(
    name: 'Professional',
    stripe_id: 'professional-plan',
    description: "Designed for professional trainers with multiple classes, calendar and a discussion forum.",
    sort: 3
)