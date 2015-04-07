require 'rails_helper'

describe Subscription do
  it { should belong_to(:plan) }
  it { should have_many(:features).through(:plan) }
  it { should belong_to(:subscriber) }
end