require 'rails_helper'
require "cancan/matchers"

describe Group do
  include_context 'groups'

  describe '#owners' do
    subject { first_group.owners }
    it { should include group_leader_subscriber }
    it { should_not include professional_subscriber }
  end

  describe '#save_with_owner' do
    subject {
      new_group = Group.new({title: 'Saved Group'})
      new_group.save_with_owner(professional_subscriber)
      new_group.reload.owners
    }
    it { should include professional_subscriber }
  end

  describe '#owners_enabled_count' do
    describe 'when limited' do
      subject { first_group.owners_enabled_count }
      it { should eq 1 }
    end
    describe 'when unlimited' do
      subject { second_group.owners_enabled_count }
      it { should eq PaidUp::Unlimited.to_i }
    end
  end

  describe '#owners_records' do
    subject { second_group.owners_records }
    it { should include third_group }
    it { should_not include first_group }
  end

  describe '#owners_records_count' do
    subject { second_group.owners_records_count }
    it { should eq 2 }
  end

  describe '#enabled?' do
    describe 'when true' do
      subject { first_group.enabled? }
      it { should eq true }
    end
    describe 'when false' do
      subject { disabled_group.enabled? }
      it { should eq false }
    end
  end
end