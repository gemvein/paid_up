# Preview all emails at http://localhost:3000/rails/mailers/subscription_mailer
class SubscriptionMailerPreview < ActionMailer::Preview
  def failed_payment_email
    @invoice = nil
    SubscriptionMailer.failed_payment_email
  end
end
