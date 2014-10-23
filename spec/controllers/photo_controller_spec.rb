require 'rails_helper'

RSpec.describe PhotoController, :type => :controller do
  describe "when loading the initial page" do
    it "should return the success HTTP code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(:success)
    end

    it "should render the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "should load no results" do
      get :index
      expect(assigns(:results)).to be_empty
    end
  end

  describe "when searching for photos" do
    it "should return an error if empty search" do
      post :search, :search_input => ""
      expect(flash[:error_msg]).to eq("Please enter some text to search for...")
    end

    it "should return an error if whitespace search" do
      post :search, :search_input => "    "
      expect(flash[:error_msg]).to eq("Please enter some text to search for...")
    end

    it "should return maximum items for a popular search" do
      post :search, :search_input => "cats"
      expect(assigns(:results).length).to eq(5)
    end

    it "should return zero items for a rubbish search" do
      post :search, :search_input => "djsaljdkasjd79371289312jkdsajlkdj"
      expect(assigns(:results).length).to eq(0)
    end

    it "should contain different results on page 2" do
      post :search, :search_input => "cats"
      page1_results = assigns(:results)

      post :search, :search_input => "cats", :page => 2
      page2_results = assigns(:results)

      expect(page1_results).not_to match_array(page2_results)
    end
  end
end