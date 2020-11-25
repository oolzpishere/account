require 'rails_helper'

module Account
  RSpec.describe PhoneVerificationControllerController, type: :controller do

    describe "GET #check_verification_code" do
      it "returns http success" do
        get :check_verification_code
        expect(response).to have_http_status(:success)
      end
    end

  end
end
