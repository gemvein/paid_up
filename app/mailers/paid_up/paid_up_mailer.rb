module PaidUp
  class PaidUpMailer < ActionMailer::Base
    default from: PaidUp.configuration.mail_from_address
    layout 'mailer'
  end
end