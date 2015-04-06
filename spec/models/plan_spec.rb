require 'rails_helper'

describe Plan do
  it { should have_many(:subscriptions) }
  it { should have_many(:subscribers).through(:subscriptions) }
  it { should have_many(:features) }
end