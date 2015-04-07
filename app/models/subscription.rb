class Subscription < ActiveRecord::Base
  belongs_to :plan
  belongs_to :subscriber, :polymorphic => true
  has_many :groups
  has_many :features, through: :plan
end