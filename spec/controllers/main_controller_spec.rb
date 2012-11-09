require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MainController do
  integrate_views
  #fixtures :users, :comments, :votes, :tags

  describe "GET index" do

    it "loads" do
      get :index
      response.code.should eq 200
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end
end