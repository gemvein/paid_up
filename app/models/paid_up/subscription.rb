class PaidUp::Subscription < ActiveRecord::Base
  belongs_to :plan, class_name: 'PaidUp::Plan'
  belongs_to :subscriber, :polymorphic => true
  has_many :features, through: :plan, class_name: 'PaidUp::Feature'
end