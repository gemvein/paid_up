shared_context 'stripe' do
  let(:default_card_data) {
    {
        number: '4242424242424242',
        exp_month: 1,
        exp_year: 45,
        cvc: '111'
    }
  }
end
def working_stripe_token(subscriber, card_hash = default_card_data)
  unless subscriber.stripe_id.present?
    customer = Stripe::Customer.create(
        email: subscriber.email
    )
    subscriber.stripe_id = customer.id
    subscriber.save
    subscriber.reload
  end
  Stripe::Token.create(
    card: card_hash
  ).id
end