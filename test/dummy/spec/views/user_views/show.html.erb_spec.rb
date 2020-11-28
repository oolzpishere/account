require 'rails_helper'

RSpec.describe "user_views/show", type: :view do
  before(:each) do
    @user_view = assign(:user_view, UserView.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
