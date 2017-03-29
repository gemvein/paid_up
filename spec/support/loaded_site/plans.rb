# frozen_string_literal: true

shared_context 'plans' do
  let!(:anonymous_plan) { PaidUp::Plan.find_by_stripe_id('anonymous-plan') }
  let!(:free_plan) { PaidUp::Plan.find_by_stripe_id('free-plan') }
  let!(:no_ads_plan) { PaidUp::Plan.find_by_stripe_id('no-ads-plan') }
  let!(:group_leader_plan) do
    PaidUp::Plan.find_by_stripe_id('group-leader-plan')
  end
  let!(:professional_plan) do
    PaidUp::Plan.find_by_stripe_id('professional-plan')
  end
end
