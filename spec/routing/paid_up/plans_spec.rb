# frozen_string_literal: true

require 'rails_helper'

describe 'PaidUp::Routing' do
  include_context 'loaded site'
  routes { PaidUp::Engine.routes }

  describe 'routes to the list of all plans' do
    subject { get plans_path }
    it { should route_to(controller: 'paid_up/plans', action: 'index') }
  end
end
