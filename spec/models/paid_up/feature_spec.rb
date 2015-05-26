require 'rails_helper'

describe PaidUp::Feature do
  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:setting_type) }
  it { should validate_inclusion_of(:setting_type).in_array(%w(boolean table_rows rolify_rows))}

  include_context 'plans and features'
  context '#feature_model' do
    subject { groups_feature.feature_model }
    it { should eq Group }
  end

  context '#feature_model_name' do
    subject { groups_feature.feature_model_name }
    it { should eq 'Group' }
  end

  context '.raw' do
    subject { PaidUp::Feature.raw }
    it { should eq( { ad_free: ad_free_feature, groups: groups_feature, doodads: doodads_feature } ) }
  end

  context '.all' do
    subject { PaidUp::Feature.all }
    it { should eq [ad_free_feature, groups_feature, doodads_feature] }
  end

  context '.find_all' do
    subject { PaidUp::Feature.find_all( setting_type: 'rolify_rows') }
    it { should be_an Array }
  end

  context '.find' do
    subject { PaidUp::Feature.find(slug: 'groups') }
    it { should be_a PaidUp::Feature }
  end
end