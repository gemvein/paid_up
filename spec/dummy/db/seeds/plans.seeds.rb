PaidUp::Plan.create(
        name: 'Free',
        description: "Can't beat the price!",
        sort: 0
)
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
PaidUp::Plan.create(
    name: 'No Ads',
    stripe_id: 'no-ads-plan',
    description: "No frills, just removes the ads.",
    sort: 1
)
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
PaidUp::Plan.create(
    name: 'Group Leader',
    stripe_id: 'group-leader-plan',
    description: "For leaders of single groups, with log configuration.",
    sort: 2
)
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
PaidUp::Plan.create(
    name: 'Professional',
    stripe_id: 'professional-plan',
    description: "Designed for professional trainers with multiple classes, calendar and a discussion forum.",
    sort: 3
)