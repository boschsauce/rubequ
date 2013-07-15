require 'spec_helper'

describe Song do
  before(:each) do
    @song = FactoryGirl.build(:song)
  end

  it "should validate that name can not be blank" do
    @song.name = ""
    @song.should have(1).error_on(:name)
  end

  it "should validate that band can not be blank" do
    @song.band = ""
    @song.should have(1).error_on(:band)
  end

  it "should validate that mp3 can not be blank" do
    @song.mp3 = nil
    @song.should have(1).error_on(:mp3)
  end

  it "should replace the public folder from the path to get the download url for the mp3" do
    @song.mp3.stub(:path).and_return("public/test/music/imsexyandiknowit.mp3")
    @song.mp3_public_path.should eq "/test/music/imsexyandiknowit.mp3"
  end

  it "release date formatted should return the date as mm/dd/yyyy" do
    @song.release_date_formatted.should eq "06/21/2011"
  end

  it "combines the band and the song name together" do
    @song.band_and_song_name_formatted.should eq "LMAFO I'm Sexy And I Know It"
  end
end
