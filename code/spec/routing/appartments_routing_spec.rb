require "rails_helper"

RSpec.describe AppartmentsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/appartments").to route_to("appartments#index")
    end

    it "routes to #new" do
      expect(get: "/appartments/new").to route_to("appartments#new")
    end

    it "routes to #show" do
      expect(get: "/appartments/1").to route_to("appartments#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/appartments/1/edit").to route_to("appartments#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/appartments").to route_to("appartments#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/appartments/1").to route_to("appartments#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/appartments/1").to route_to("appartments#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/appartments/1").to route_to("appartments#destroy", id: "1")
    end
  end
end
