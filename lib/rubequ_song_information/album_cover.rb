require 'discogs'

module RubequSongInformation
  class AlbumCover
    def initialize
    end

    def get_cover(name)
      begin
        wrapper = discog_wrapper
        wrapper.nil? ? default_image : album_cover(wrapper, name)
      rescue Exception => e
        puts e
        default_image
      end
    end

    def default_image
      "http://s.pixogs.com/images/record150.png"
    end

    def album_cover(wrapper, name)
      search = wrapper.search(name)
      search.results.first.thumb
    end

    def discog_wrapper
      Discogs::Wrapper.new("rubequ")
    end
  end
end

