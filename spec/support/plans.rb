shared_context "plans" do
  let!(:anonymous_plan) { PaidUp::Plan.find_by_stripe_id('anonymous-plan') }
  let!(:free_plan) { PaidUp::Plan.find_by_stripe_id('free-plan') }
  let!(:no_ads_plan) { PaidUp::Plan.find_by_stripe_id('no-ads-plan') }
  let!(:group_leader_plan) { PaidUp::Plan.find_by_stripe_id('group-leader-plan') }
  let!(:professional_plan) { PaidUp::Plan.find_by_stripe_id('professional-plan') }
end