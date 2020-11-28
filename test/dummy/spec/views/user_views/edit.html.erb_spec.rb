require 'rails_helper'

RSpec.describe "user_views/edit", type: :view do
  before(:each) do
    @user_view = assign(:user_view, UserView.create!())
  end

  it "renders the edit user_view form" do
    render

    assert_select "form[action=?][method=?]", user_view_path(@user_view), "post" do
    end
  end
end
