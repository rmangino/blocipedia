require 'rails_helper'

describe Wiki do

  include TestFactories

  describe "scopes" do

    before do
      @public_wiki  = Wiki.create(title: "public wiki title", body: "public wiki body")
      @private_wiki = Wiki.create(title: "private wiki title", body: "private wiki body", private: true)
    end

    describe "publicly_viewable" do
      it "returns a relation of all public wikis" do
        expect( Wiki.publicly_viewable ).to eq( [@public_wiki] )
      end
    end

    describe "privately_viewable" do
      it "returns a relation of all private wikis" do
        expect( Wiki.privately_viewable ).to eq( [@private_wiki] )
      end
    end

    describe "visible_to(user)" do

      before do
        @free_user    = authenticated_user({role: :free})
        @free_user_public_wiki = Wiki.create(title: "public wiki title", body: "public wiki body")

        @premium_user = authenticated_user({role: :premium})
        @premium_user_public_wiki  = Wiki.create(title: "premium wiki title", body: "premium wiki body")
        @premium_user_private_wiki = Wiki.create(title: "premium wiki title", body: "premium wiki body", private: true)

        @admin_user   = authenticated_user({role: :admin})
      end

      it "should return all wikis for an admin user" do
        expect( Wiki.visible_to(@admin_user).count ).to eq( Wiki.count )
      end

      it "should return public wikis for a free user" do
        expect( Wiki.visible_to(@free_user).count ).to eq( Wiki.publicly_viewable.count )
      end

      it "should return public wikis and private wikis belonging to user for a premium user" do
        public_wiki_count  = Wiki.publicly_viewable.count
        private_wiki_count = Wiki.where(user: @premium_user).where(private: true).count

        expect( Wiki.visible_to(@premium_user).count ).to eq( public_wiki_count + private_wiki_count )
      end

      it "should return public and private wikis for an admin user" do
        expect( Wiki.visible_to(@admin_user).count ).to eq( Wiki.count )
      end

    end

  end # describe "scopes"

end