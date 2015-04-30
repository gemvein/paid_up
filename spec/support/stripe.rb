shared_context 'stripe' do
  let!(:working_stripe_token) {
    Stripe::Token.create(
      :card => {
          :number => "4242424242424242",
          :exp_month => 4,
          :exp_year => 2016,
          :cvc => "314"
      },
    ).id
  }
end