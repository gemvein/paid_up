PaidUp::Plan.create(
        name: 'Free',
        charge: '0.00',
        period: 'Month',
        cycles: 1,
        description: "Can't beat the price!",
        sort: 0
)
PaidUp::Plan.create(
    name: 'No Ads',
    charge: '1.00',
    period: 'Month',
    cycles: 1,
    description: "No frills, just removes the ads.",
    sort: 1
)
PaidUp::Plan.create(
    name: 'Group Leader',
    charge: '5.00',
    period: 'Month',
    cycles: 1,
    description: "For leaders of single groups, with log configuration.",
    sort: 2
)
PaidUp::Plan.create(
    name: 'Professional',
    charge: '10.00',
    period: 'Month',
    cycles: 1,
    description: "Designed for professional trainers with multiple classes, calendar and a discussion forum.",
    sort: 3
)