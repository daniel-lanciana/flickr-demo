require 'rails_helper'

RSpec.describe "home page", :type => :request do
  it "display search results after submitting" do
    get "/"
    assert_select "form" do
      assert_select "input[search_input=?]", "cats"
    end

    post "/photo/search", :search_input => "cats"
    assert_select ".thumbs", :text => "jdoe"
  end

  it "displays the user's username after successful login" do
    #user = FactoryGirl.create(:user, :username => "jdoe", :password => "secret")
    visit "/"
    fill_in "search_input", :with => "cats"
    click_button "Search"

    expect(page).to have_selector(".thumbs")
  end
end