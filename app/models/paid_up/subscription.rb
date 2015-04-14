class PaidUp::Subscription < ActiveRecord::Base
  belongs_to :plan, class_name: 'PaidUp::Plan'
  belongs_to :subscriber, :polymorphic => true
  has_many :features, through: :plan, class_name: 'PaidUp::Feature'
  scope :charged_after, ->(time) { where("charged_at > ?", time) }
  scope :current, -> { charged_after(plan.current_date.to_s(:db)) }

  def is_current?
    charged_at > plan.current_date
  end
end