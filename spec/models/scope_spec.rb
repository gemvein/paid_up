require 'rails_helper'
require 'cancan/matchers'

describe 'Scopes' do
  include_context 'loaded site'

  describe 'paid_for#owners_records' do
    subject { first_post.owners_records }
    it { should include active_post }
    it { should_not include inactive_post }
  end

  describe 'paid_for#enabled' do
    describe 'when it is within the limit' do
      subject { still_enabled_post.enabled }
      it { should be true }
    end
    describe 'when it is NOT within the limit' do
      subject { no_longer_enabled_post.enabled }
      it { should be false }
    end
  end

  describe 'user#table_rows' do
    subject { free_subscriber.table_rows('posts') }
    it { should eq 4 }
  end

  describe 'user#rolify_rows' do
    subject { group_leader_subscriber.rolify_rows('groups') }
    it { should eq 1 }
  end
end