class PaidUp::Subscription < ActiveRecord::Base
  belongs_to :plan, class_name: 'PaidUp::Plan'
  belongs_to :subscriber, :polymorphic => true
  has_many :features, through: :plan, class_name: 'PaidUp::Feature'
  scope :valid, -> { where("valid_until < ?", Time.now.to_s(:db)) }
  default_scope { valid }

  def is_current?
    valid_until < Time.now
  end
end