shared_context 'groups' do
  include_context 'subscribers'

  let!(:first_group) {
    FactoryGirl.create(
        :group,
        title: 'First Group'
    )
  }
  let!(:second_group) {
    FactoryGirl.create(
        :group,
        title: 'Second Group'
    )
  }
  let!(:third_group) {
    FactoryGirl.create(
        :group,
        title: 'Third Group'
    )
  }
  let!(:disabled_group) {
    FactoryGirl.create(
        :group,
        title: 'Disabled Group'
    )
  }
  before do
    group_leader_subscriber.add_role(:owner, first_group)
    group_leader_subscriber.add_role(:owner, disabled_group)
    professional_subscriber.add_role(:owner, second_group)
    professional_subscriber.add_role(:owner, third_group)
  end
end