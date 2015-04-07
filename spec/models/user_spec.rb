require 'rails_helper'

describe User do
  it { should have_one(:subscription).class_name('PaidUp::Subscription') }
  it { should have_one(:plan).class_name('PaidUp::Plan') }
  it { should have_many(:features).class_name('PaidUp::Feature') }
end