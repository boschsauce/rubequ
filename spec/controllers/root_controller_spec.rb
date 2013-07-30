require 'spec_helper'

describe RootController do
  before(:each) do
    mpd_mock = double
    mpd_mock.stub(:connected?).and_return("false")
    mpd_mock.stub(:volume).and_return(20)
    mpd_mock.stub(:disconnect)
    RubequMpd::Mpd.stub(:new).and_return(mpd_mock)
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'connected'" do
    it "returns connected value in json" do
      get 'connected', { :format => :json }
      response.body.should eq "false"
    end
  end

  describe "GET 'volume'" do
    it "returns volume value in json" do
      get 'volume', { :format => :json }
      response.body.should eq "20"
    end
  end

  describe "POST 'update_volume'" do
    it "returns update_volume value in json" do
      post 'update_volume', { :volume => "20", :format => :json }
      response.body.should eq "20"
    end
  end
end
