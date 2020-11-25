require 'rails_helper'

RSpec.describe "PhoneVerificationControllers", type: :request do

  describe "GET /check_verification_code" do
    it "returns http success" do
      get "/phone_verification_controller/check_verification_code"
      expect(response).to have_http_status(:success)
    end
  end

end
