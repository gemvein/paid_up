require 'rails_helper'

describe PaidUp::Subscription do
  it { should belong_to(:plan).class_name('PaidUp::Plan') }
  it { should have_many(:features).class_name('PaidUp::Feature').through(:plan) }
  it { should belong_to(:subscriber) }

  describe '#is_valid?' do
    include_context 'subscribers'
    subject { professional_subscriber.subscription.is_valid? }
    it { should be true }
  end
end