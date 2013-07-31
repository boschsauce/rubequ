require 'spec_helper'

describe "songs/show.html.erb" do
  before(:each) do
    @song = FactoryGirl.build(:song, :id => 1, :album_cover => "http://localhost/images/test.png", :name => "Test Name", :band => "Test Band")
    @song.stub(:mp3_public_path).and_return("/music/1.mp3")
    @song.stub(:in_queue?).and_return(false)
  end

  it "should render song informaiton" do
    render
    rendered.should match(/Queue Song/)
    rendered.should match(/Test Name/)
    rendered.should match(/Test Band/)
  end
end

