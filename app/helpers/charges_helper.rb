module ChargesHelper

  def self.stripe_btn_data
    { key:         "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Premium Membership Uprade!",
      name: "Upgrade To Premium Membership!",
      label: "Upgrade To Premium Membership!",
      amount:      Amount.default }
  end

end
