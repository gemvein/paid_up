# frozen_string_literal: true

shared_context 'users' do
  let(:free_subscriber) { User.find_by_name('Free Subscriber') }
  let(:no_ads_subscriber) { User.find_by_name('No Ads Subscriber') }
  let(:group_leader_subscriber) { User.find_by_name('Group Leader Subscriber') }
  let(:professional_subscriber) { User.find_by_name('Professional Subscriber') }
  let(:blank_subscriber) { User.find_by_name('Blank Subscriber') }
  let(:disabling_subscriber) { User.find_by_name('Disabling Subscriber') }
end
