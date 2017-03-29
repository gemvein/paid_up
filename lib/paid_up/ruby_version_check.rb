# frozen_string_literal: true

if RUBY_VERSION < '2.3.0' && RUBY_ENGINE == 'ruby'
  desc = if defined?(RUBY_DESCRIPTION)
           RUBY_DESCRIPTION
         else
           "ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE})"
         end
  abort <<-end_message
    This version of PaidUp requires Ruby 2.3.0 or newer.
    You're running
      #{desc}
    Please upgrade to Ruby 2.3.0 or newer to continue.
  end_message
end
