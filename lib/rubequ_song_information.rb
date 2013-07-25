require 'discogs'
require 'lyricfy'

module RubequSongInformation
  class AlbumCover
    def initialize
    end

    def get_cover(name)
      begin
        wrapper = Discogs::Wrapper.new("rasplay")
        if wrapper.nil?
          default_image
        else
          search = wrapper.search(name)
          results = search.results.first
          results.thumb
        end
      rescue Exception => e
        puts e
        default_image
      end
    end

    def default_image
      "http://s.pixogs.com/images/record150.png"
    end
  end

  class Lyrics
    def initialize
    end

    def get_lyrics(band, song_name)
      fetcher = Lyricfy::Fetcher.new
      song = fetcher.search band, song_name
      song.body("<br>")
    end
  end
end

