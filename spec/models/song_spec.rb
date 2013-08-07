require 'spec_helper'

Music = Struct.new(:file)

describe Song do
  before(:each) do
    @mpd_mock = double
    @mpd_mock.stub(:disconnect)
    RubequMpd::Mpd.stub(:new).and_return(@mpd_mock)
    @song = FactoryGirl.build(:song, :play_count => 1)
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
    before(:each) do
      @music_struct = Music.new("test.mp3")
      @mpd_mock.stub(:current_song).and_return(Music.new("1.mp3"))
      @mpd_mock.stub(:song_by_file).and_return(@music_struct)
    end

    it "should call add to queue in mpd lib" do
      @mpd_mock.should_receive(:queue_add).with(@music_struct)
      @song.add_to_queue
    end

    it "should increment the play count when added to the queue" do
      @mpd_mock.should_receive(:queue_add).with(@music_struct)
      @song.add_to_queue
      @song.play_count.should eq 2
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

  describe "all in queue" do
    it "should return all songs in the queue" do
      @mpd_mock.stub(:queued_song_ids).and_return(["4", "2", "1"])
      @mpd_mock.stub(:current_song_id).and_return("2")
      Song.stub(:unscoped).and_return(Song)
      Song.should_receive(:where).with({:id => ["4", "1"]})
      Song.all_in_queue
    end

    it "should delete current song from queue songs" do
      queued_song_ids = ["1", "2", "3"]
      @mpd_mock.stub(:queued_song_ids).and_return(queued_song_ids)
      @mpd_mock.stub(:current_song_id).and_return("2")
      queued_song_ids.should_receive(:delete).with("2")
      Song.all_in_queue
    end

    it "should sort the songs in the queue based on the ids that come back from mpd queue song ids" do
      queued_song_ids = ["1", "2", "3"]
      @mpd_mock.stub(:queued_song_ids).and_return(queued_song_ids)
      @mpd_mock.stub(:current_song_id).and_return(nil)

      @song_one   = FactoryGirl.build(:song, :id => "1")
      @song_two   = FactoryGirl.build(:song, :id => "2")
      @song_three = FactoryGirl.build(:song, :id => "3")

      unsorted_songs_array = [@song_three, @song_one, @song_two]

      Song.stub_chain(:unscoped, :where).with({:id => queued_song_ids}).and_return(unsorted_songs_array)
      Song.all_in_queue.should eq [@song_one, @song_two, @song_three]
    end
  end

  describe "music player controls " do
    it "should validate that next is called" do
      @mpd_mock.should_receive(:next)
      Song.next
    end

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
