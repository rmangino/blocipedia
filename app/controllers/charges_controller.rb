class ChargesController < ApplicationController

  def create
    # Create a Stripe Customer object for associating with the charge
    customer = Stripe::Customer.create(email: current_user.email,
                                       card:  params[:stripeToken])

    # Create a Stripe charge for this customer
    charge = Stripe::Charge.create(
      customer: customer.id, # Note -- this is NOT the same as user_id
      amount: Amount.default,
      description: "Premium Membership!",
      currency: 'usd'
    )

    flash[:success] = "Thank you for your payment!"
    current_user.premium! # Upgrade user to our Premium level

    redirect_to root_path

  rescue Stripe::CardError => e

    flash[:error] = e.message
    redirect_to root_path
  end

  def downgrade
    if current_user && current_user.premium?
      current_user.free!

      current_user.wikis.each do |wiki|
        wiki.update_attributes!(private: false)
      end

      flash[:success] = "Successfully Downgraded To Free Account"
      redirect_to edit_user_registration_path
    end
  end

end
