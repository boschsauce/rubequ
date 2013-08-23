require 'spec_helper'

Music = Struct.new(:file)

describe Song do
  before(:each) do
    @mpd_mock = double
    @mpd_mock.stub(:disconnect)
    @mpd_mock.stub(:connect)
    @mpd_mock.stub(:consume)


    @song = FactoryGirl.build(:song, :play_count => 1)

    RubequMpd::Mpd.any_instance.stub(:initialize_mpd).and_return(@mpd_mock)
    RubequMpd::Mpd.any_instance.stub(:consume).and_return(true)
    RubequSongInformation::AlbumCover.any_instance.stub(:discog_wrapper).and_return(nil)
    RubequSongInformation::AlbumCover.any_instance.stub(:get_cover).and_return("http://s.pixogs.com/images/record150.png")
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

  describe "music player controls " do
    it "should validate that next is called" do
      @mpd_mock.stub(:next)
      @mpd_mock.should_receive(:next)
      Song.next
    end

    it "should validate that play is called" do
      @mpd_mock.stub(:play)
      @mpd_mock.should_receive(:play)
      Song.play
    end

    it "should validate that paused is called" do
      @mpd_mock.stub(:paused?) { false }
      @mpd_mock.stub(:pause=).with(true)
      @mpd_mock.should_receive(:pause=)
      Song.pause
    end
  end
end
