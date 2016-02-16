module PaidUp::Extensions
  module Stripe
    extend ActiveSupport::Concern
    class_methods do
      def find_or_create_by_id(id, item)
        begin
          self.retrieve(id)
        rescue
          item[:id] ||= id
          self.create(item)
        end
      end
    end
  end
end