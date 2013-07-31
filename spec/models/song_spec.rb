require 'spec_helper'

Music = Struct.new(:file)

describe Song do
  before(:each) do
    @mpd_mock = double
    @mpd_mock.stub(:disconnect)
    RubequMpd::Mpd.stub(:new).and_return(@mpd_mock)
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

  describe "add to queue" do
    it "should call add to queue in mpd lib" do
      @music_struct = Music.new("test.mp3")
      @mpd_mock.stub(:current_song).and_return(Music.new("1.mp3"))
      @mpd_mock.stub(:song_by_file).and_return(@music_struct)
      @mpd_mock.should_receive(:queue_add).with(@music_struct)
      @song.add_to_queue
    end
  end

  describe "current song " do
    it "should return the nil when there is no current song" do
      @mpd_mock.stub(:current_song).and_return(nil)
      Song.current_song.should eq nil
    end

    it "should return the current song when current song is not blank and found in songs" do
      @mpd_mock.stub(:current_song).and_return(Music.new("1.mp3"))
      Song.stub(:by_file).and_return(@song)
      Song.current_song.should eq @song
    end

    it "should validate current_song was called" do
      @mpd_mock.should_receive(:current_song)
      Song.current_song
    end
  end

  describe "music player controls " do
    it "should validate that play is called" do
      @mpd_mock.should_receive(:play)
      Song.play
    end

    it "should validate that paused is called" do
      @mpd_mock.should_receive(:pause)
      Song.pause
    end
  end
end
