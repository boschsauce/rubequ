require 'spec_helper'

describe "songs/show.html.erb" do
  before(:each) do
    @song = FactoryGirl.build(:song, :id => 1, :album_cover => "http://localhost/images/test.png", :name => "Test Name", :band => "Test Band")
    @song.stub(:mp3_public_path).and_return("/music/1.mp3")
    @song.stub(:in_queue?).and_return(false)
    @song.stub(:last_played).and_return(2.days.ago)
    @song.stub(:play_count).and_return(6)
  end

  it "should render song informaiton" do
    render
    rendered.should match(/Queue Song/)
    rendered.should match(/Test Name/)
    rendered.should match(/Test Band/)
    rendered.should match(/Play Count: 6/)
    rendered.should match(/Last Played: 2 days/)
  end
end

