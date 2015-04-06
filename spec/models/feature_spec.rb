require 'rails_helper'

describe Feature do
  it { should have_many(:plans) }
end