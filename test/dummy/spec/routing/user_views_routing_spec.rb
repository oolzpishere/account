require "rails_helper"

RSpec.describe UserViewsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/user_views").to route_to("user_views#index")
    end

    it "routes to #new" do
      expect(get: "/user_views/new").to route_to("user_views#new")
    end

    it "routes to #show" do
      expect(get: "/user_views/1").to route_to("user_views#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/user_views/1/edit").to route_to("user_views#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/user_views").to route_to("user_views#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/user_views/1").to route_to("user_views#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/user_views/1").to route_to("user_views#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/user_views/1").to route_to("user_views#destroy", id: "1")
    end
  end
end
