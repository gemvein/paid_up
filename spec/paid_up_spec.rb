require 'rails_helper'

describe 'PaidUp' do
  it 'should return correct version string' do
    PaidUp.version_string.should == "PaidUp version #{PaidUp::VERSION}"
  end
end
