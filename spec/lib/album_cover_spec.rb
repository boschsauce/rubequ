require 'spec_helper'

describe RubequSongInformation::AlbumCover do
  before(:each) do
    @album_cover = RubequSongInformation::AlbumCover.new
  end

  it "should have the url for a default images" do
    @album_cover.default_image.should eq  "http://s.pixogs.com/images/record150.png"
  end

  it "should return default image when album wrapper is not valid" do
    @album_cover.stub(:discog_wrapper).and_return(nil)
    @album_cover.get_cover("not a valid name").should eq @album_cover.default_image
  end

  it "should call album_cover with the wrapper and the name so it can return the result of the first album cover" do
    DiscogMock = Struct.new(:search)
    discog_mock = DiscogMock.new
    @album_cover.stub(:discog_wrapper).and_return(discog_mock)
    @album_cover.should_receive(:album_cover).with(discog_mock, "LMAFO")
    @album_cover.get_cover("LMAFO")
  end
end
