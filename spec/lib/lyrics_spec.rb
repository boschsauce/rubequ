require 'spec_helper'


describe RubequSongInformation::Lyrics do

  before(:each) do
    @lyrics = RubequSongInformation::Lyrics.new
  end

  it "should seperate the body of the lyrics with a <br>" do
    @lyrics.body_seperator.should eq "<br>"
  end

  it "should search for lyrics with the band and song name" do
    LyricfyMock = Struct.new(:search)
    lyricfy = LyricfyMock.new

    @lyrics.stub(:lyricfy).and_return(lyricfy)
    lyricfy.should_receive(:search).with("LMAFO", "I'm sexy and I know it")
    @lyrics.get_lyrics("LMAFO", "I'm sexy and I know it")
  end

  it "should parse the body of the lyrics with the body seperator" do
    LyricfySearch = Struct.new(:body)
    search = LyricfySearch.new
    search.should_receive(:body).with("<br>")
    @lyrics.parse_search(search)
  end
end
