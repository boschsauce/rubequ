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

  describe "all in queue" do
    it "should return all songs in the queue" do
      RubequMpd::Mpd.any_instance.stub(:queued_song_ids).and_return(["4", "2", "1"])
      RubequMpd::Mpd.any_instance.stub(:current_song_id).and_return("2")
      Song.stub(:unscoped).and_return(Song)
      Song.should_receive(:where).with({:id => ["4", "1"]})
      Song.all_in_queue
    end
    it "should delete current song from queue songs" do
      queued_song_ids = ["1", "2", "3"]
      RubequMpd::Mpd.any_instance.stub(:queued_song_ids).and_return(queued_song_ids)
      RubequMpd::Mpd.any_instance.stub(:current_song_id).and_return("2")
      queued_song_ids.should_receive(:delete).with("2")
      Song.all_in_queue
    end

    it "should sort the songs in the queue based on the ids that come back from mpd queue song ids" do
      queued_song_ids = ["1", "2", "3"]
      RubequMpd::Mpd.any_instance.stub(:queued_song_ids).and_return(queued_song_ids)
      RubequMpd::Mpd.any_instance.stub(:current_song_id).and_return(nil)

      @song_one   = FactoryGirl.build(:song, :id => "1")
      @song_two   = FactoryGirl.build(:song, :id => "2")
      @song_three = FactoryGirl.build(:song, :id => "3")

      unsorted_songs_array = [@song_three, @song_one, @song_two]

      Song.stub_chain(:unscoped, :where).with({:id => queued_song_ids}).and_return(unsorted_songs_array)
      Song.all_in_queue.should eq [@song_one, @song_two, @song_three]
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
