module PaidUp
  module Extensions
    # Stripe Extensions
    module Stripe
      extend ActiveSupport::Concern
      class_methods do
        def find_or_create_by_id(id, item)
          retrieve(id)
        rescue
          item[:id] ||= id
          create(item)
        end
      end
    end
  end
end
