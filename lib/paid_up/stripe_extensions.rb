module PaidUp
  module StripeExtensions
    extend ActiveSupport::Concern
    class_methods do
      def find_or_create_by_id(id, item)
        begin
          self.retrieve(id)
        rescue
          self.create(item)
        end
      end
    end
  end
end

Stripe::Customer.send(:include, PaidUp::StripeExtensions)
Stripe::Plan.send(:include, PaidUp::StripeExtensions)