require "rails_helper"

RSpec.describe VisitCommentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/visit_comments").to route_to("visit_comments#index")
    end

    it "routes to #new" do
      expect(get: "/visit_comments/new").to route_to("visit_comments#new")
    end

    it "routes to #show" do
      expect(get: "/visit_comments/1").to route_to("visit_comments#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/visit_comments/1/edit").to route_to("visit_comments#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/visit_comments").to route_to("visit_comments#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/visit_comments/1").to route_to("visit_comments#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/visit_comments/1").to route_to("visit_comments#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/visit_comments/1").to route_to("visit_comments#destroy", id: "1")
    end
  end
end
