require 'lyricfy'

module RubequSongInformation
  class Lyrics
    def initialize
    end

    def get_lyrics(band, song_name)
      lyricfy.search(band, song_name).body(body_seperator)
    end

    def body_seperator
      "<br>"
    end

    def lyricfy
      Lyricfy::Fetcher.new
    end
  end
end

