require 'rails_helper'

describe PaidUp::Feature do
  it { should have_many(:plans) }
end