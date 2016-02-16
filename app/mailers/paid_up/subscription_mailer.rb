module PaidUp
  class SubscriptionMailer < PaidUpMailer
    def payment_failed_email(invoice)
      @invoice = invoice
      @user = User.find_by_stripe_id(@invoice.customer)
      mail(to: @user.email, subject: :your_site_subscription_payment_failed.l(site: PaidUp.configuration.site_name))
    end
  end
end
