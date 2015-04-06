require 'rails_helper'

describe User do
  it { should have_one(:subscription) }
  it { should have_one(:plan) }
  it { should have_many(:features) }
end