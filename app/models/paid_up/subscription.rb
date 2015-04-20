class PaidUp::Subscription < ActiveRecord::Base
  belongs_to :plan, class_name: 'PaidUp::Plan'
  has_many :features, through: :plan, class_name: 'PaidUp::Feature'
  belongs_to :subscriber, :polymorphic => true

  scope :valid, -> { where("valid_until > ?", Time.now.to_s(:db)) }
  default_scope { valid }

  def is_valid?
    valid_until > Time.now
  end
end