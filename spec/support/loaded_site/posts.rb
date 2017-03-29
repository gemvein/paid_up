# frozen_string_literal: true

shared_context 'posts' do
  let(:first_post) { Post.find_by_title('First Post') }
  let(:active_post) { Post.find_by_title('Active Post') }
  let(:inactive_post) { Post.find_by_title('Inactive Post') }
  let(:still_enabled_post) { Post.find_by_title('Still Enabled Post') }
  let(:no_longer_enabled_post) { Post.find_by_title('No Longer Enabled Post') }
end
