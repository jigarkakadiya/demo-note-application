class ChargesController < ApplicationController
  def new; end

  def create
    @amount = params[:amount]
    customer = Stripe::Customer.create({
      email: params[:stripeEmail],
      source: params[:stripeToken],
    })
    charge = Stripe::Charge.create({
      customer: customer.id,
      amount: @amount,
      description: 'Rails Stripe customer',
      currency: 'usd',
    })
    current_user.update(stripe_id: charge.id)
    @amount = @amount.to_i / 100
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
  end

  def refund
      refund = Stripe::Refund.create({
        charge: current_user.stripe_id,
      })
      p refund
      amount = refund.amount.to_i / 100
      flash[:msg] = amount.to_s + " has been refunded to your account which was used for payment"
    rescue Stripe::InvalidRequestError => e
      flash[:msg] = "Money has already been refunded to your account which was used for payment"
  end
end
