require 'rails_helper'

RSpec.describe "user_views/index", type: :view do
  before(:each) do
    assign(:user_views, [
      UserView.create!(),
      UserView.create!()
    ])
  end

  it "renders a list of user_views" do
    render
  end
end
