# frozen_string_literal: true

shared_context 'loaded site' do
  include_context 'plans'
  include_context 'features'
  include_context 'stripe'
  include_context 'users'
  include_context 'groups'
  include_context 'posts'
end
