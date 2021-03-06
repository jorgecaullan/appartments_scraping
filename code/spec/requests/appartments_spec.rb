 require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/appartments", type: :request do
  
  # Appartment. As you add validations to Appartment, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Appartment.create! valid_attributes
      get appartments_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      appartment = Appartment.create! valid_attributes
      get appartment_url(appartment)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_appartment_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      appartment = Appartment.create! valid_attributes
      get edit_appartment_url(appartment)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Appartment" do
        expect {
          post appartments_url, params: { appartment: valid_attributes }
        }.to change(Appartment, :count).by(1)
      end

      it "redirects to the created appartment" do
        post appartments_url, params: { appartment: valid_attributes }
        expect(response).to redirect_to(appartment_url(Appartment.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Appartment" do
        expect {
          post appartments_url, params: { appartment: invalid_attributes }
        }.to change(Appartment, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post appartments_url, params: { appartment: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested appartment" do
        appartment = Appartment.create! valid_attributes
        patch appartment_url(appartment), params: { appartment: new_attributes }
        appartment.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the appartment" do
        appartment = Appartment.create! valid_attributes
        patch appartment_url(appartment), params: { appartment: new_attributes }
        appartment.reload
        expect(response).to redirect_to(appartment_url(appartment))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        appartment = Appartment.create! valid_attributes
        patch appartment_url(appartment), params: { appartment: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested appartment" do
      appartment = Appartment.create! valid_attributes
      expect {
        delete appartment_url(appartment)
      }.to change(Appartment, :count).by(-1)
    end

    it "redirects to the appartments list" do
      appartment = Appartment.create! valid_attributes
      delete appartment_url(appartment)
      expect(response).to redirect_to(appartments_url)
    end
  end
end
