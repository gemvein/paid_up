shared_context 'groups' do
  let(:first_group) { Group.find_by_title('First Group') }
  let(:second_group) { Group.find_by_title('Second Group') }
  let(:third_group) { Group.find_by_title('Third Group') }
  let(:disabled_group) { Group.find_by_title('Disabled Group') }
end
