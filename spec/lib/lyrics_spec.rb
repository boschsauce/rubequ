require 'spec_helper'

describe RubequSongInformation::Lyrics do

  it "should seperate the body of the lyrics with a <br>" do
    RubequSongInformation::Lyrics.new.body_seperator.should eq "<br>"
  end
end
