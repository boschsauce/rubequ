require 'spec_helper'

describe SongsController do
  before(:each) do
    @song = stub_model(Song, :id => 1)
    Song.stub(:find).and_return(@song)
    Song.stub(:all).and_return([@song])
    Song.stub(:destroy).and_return(true)
    Song.any_instance.stub(:in_queue).and_return(false)
    Song.any_instance.stub(:save_attached_files).and_return(true)
    Song.any_instance.stub(:set_album_cover).and_return("http://a5.mzstatic.com/us/r1000/086/Features/1f/76/c9/dj.uqxkqdqp.170x170-75.jpg")
    Song.any_instance.stub(:lyrics).and_return("This is the awesome stuff.")
  end

  def valid_attributes
    { :name => "I'm Sexy And I Know It", :band => "LMFAO", :mp3 => Rack::Test::UploadedFile.new(Rails.root + 'spec/factories/music/ImSexyAndIKnowIt.mp3')  }
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index', :format => :json
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', :id => @song.id, :format => :json
      response.should be_success
    end
  end

  describe "GET 'lyrics'" do
    it "returns http success" do
      get 'lyrics', :song_id => @song.id, :format => :json
      response.body.should eq "\"This is the awesome stuff.\""
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "assigns a newly created song as @song" do
      post :create, {:song => valid_attributes, :format => :json }
      assigns(:song).should be_a(Song)
      assigns(:song).should be_persisted
    end

    it "renders a 201 status created code" do
      post :create, {:song => valid_attributes, :format => :json }
      response.status.should eq 201
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved song as @song" do
        Song.any_instance.stub(:save).and_return(false)
        post :create, {:song => { "name" => "" }, :format => :json }
        assigns(:song).should be_a_new(Song)
      end

      it "renders the error template when errors are found" do
        Song.any_instance.stub(:save).and_return(false)
        post :create, {:song => { "name" => "" }, :format => :js }
        response.should render_template("songs/error")
      end
    end
  end

  describe "PUT 'update'" do
    it "returns songs update template when update is success" do
      put 'update', { :id => @song.id, :song => valid_attributes, :format => :js }
      response.should render_template("songs/update")
      response.should be_success
    end

    it "returns updated song in json format" do
      put 'update', { :id => @song.id, :song => valid_attributes, :format => :json }
      response.should be_success
    end

    describe "with invalid params" do
      it "renders the error template when errors are found" do
        Song.any_instance.stub(:save).and_return(false)
        put :update, {:id => @song.id, :song => { "name" => "" }, :format => :js }
        response.should render_template("songs/error")
      end
    end
  end

  describe "DESTROY 'destroy'" do
    it "should remove the song" do 
      @song.should_receive(:destroy)
      ass_params = { :id => @song.id, :format => :json }
      delete 'destroy', ass_params
      response.should be_success 
    end
  end
end

