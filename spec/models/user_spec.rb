require 'rails_helper'

describe User do

  include TestFactories

  describe "#can_create_private_wikis?" do

    before do
      @free_user    = authenticated_user({role: :free})
      @premium_user = authenticated_user({role: :premium})
      @admin_user   = authenticated_user({role: :admin})
    end

    it "returns false for free users" do
      expect(@free_user.can_create_private_wikis?).to be false
    end

    it "returns true for premium users" do
      expect(@premium_user.can_create_private_wikis?).to be true
    end

    it "returns true for admin users" do
      expect(@admin_user.can_create_private_wikis?).to be true
    end

  end # describe "#can_create_private_wikis?"

end