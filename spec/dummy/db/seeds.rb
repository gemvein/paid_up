###############
# Plans       #
###############

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
anonymous = PaidUp::Plan.create(
    name: 'Anonymous',
    stripe_id: 'anonymous-plan',
    description: "What you can do without logging in.",
    sort_order: -1
)
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
free = PaidUp::Plan.create(
    name: 'Free',
    stripe_id: 'free-plan',
    description: "Can't beat the price!",
    sort_order: 0
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
no_ads = PaidUp::Plan.create(
    name: 'No Ads',
    stripe_id: 'no-ads-plan',
    description: "No frills, just removes the ads.",
    sort_order: 1
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
group_leader = PaidUp::Plan.create(
    name: 'Group Leader',
    stripe_id: 'group-leader-plan',
    description: "For leaders of single groups, with configuration.",
    sort_order: 2
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
professional = PaidUp::Plan.create(
    name: 'Professional',
    stripe_id: 'professional-plan',
    description: "Designed for professionals with unlimited groups, a calendar and configuration.",
    sort_order: 3
)
######################
# Anonymous Customer #
######################
Stripe::Customer.find_or_create_by_id(
    'anonymous-customer',
    {
        id: 'anonymous-customer',
        description: 'Anonymous Customer',
        plan: 'anonymous-plan'
    }
)
#######################
# PlanFeatureSettings #
#######################

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