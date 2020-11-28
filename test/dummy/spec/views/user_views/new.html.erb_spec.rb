require 'rails_helper'

RSpec.describe "user_views/new", type: :view do
  before(:each) do
    assign(:user_view, UserView.new())
  end

  it "renders new user_view form" do
    render

    assert_select "form[action=?][method=?]", user_views_path, "post" do
    end
  end
end
