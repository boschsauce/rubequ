require 'lyricfy'

module RubequSongInformation
  class Lyrics
    def initialize
    end

    def get_lyrics(band, song_name)
      search = lyricfy.search(band, song_name)
      parse_search(search)
    end

    def body_seperator
      "<br>"
    end

    def parse_search(search)
      search.body(body_seperator) unless search.nil?
    end

    def lyricfy
      Lyricfy::Fetcher.new
    end
  end
end

