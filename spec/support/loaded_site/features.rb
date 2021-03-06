# frozen_string_literal: true

shared_context 'features' do
  let!(:ad_free_feature) { PaidUp::Feature.find_by_slug('ad_free') }
  let!(:groups_feature) { PaidUp::Feature.find_by_slug('groups') }
  let!(:doodads_feature) { PaidUp::Feature.find_by_slug('doodads') }
  let!(:posts_feature) { PaidUp::Feature.find_by_slug('posts') }
end
