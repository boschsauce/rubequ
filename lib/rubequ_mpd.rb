require 'ruby-mpd'

module RubequMpd
  attr_accessor :mpd_server, :mpd_port

  class Mpd
    attr_accessor :mpd

    def initialize
      @mpd = initialize_mpd
      connect
      consume
    end

    def initialize_mpd
      MPD.new RubequMpd.mpd_server, RubequMpd.mpd_port
    end

    def consume
      @mpd.consume = true
    end

    def connect
      begin
        @mpd.connect(true)
      rescue
        puts "Could not connect to MPD server."
        nil
      end
    end

    def connected?
      @mpd.connected?
    end

    def disconnect
      @mpd.disconnect
    end

    def current_song
      @mpd.current_song
    end

    def current_song_id
      cs = current_song
      cs.nil? ? nil : cs.file.gsub(".mp3", "")
    end

    def play
      @mpd.play
    end

    def play_song(id)
      @mpd.play(id)
    end

    def pause
      @mpd.pause = (!paused?)
    end

    def paused?
      @mpd.paused?
    end

    def stop
      @mpd.stop
    end

    def next
      @mpd.next
    end

    def current_song_name
      current_song.nil? ? "" : current_song.file.gsub(".mp3", "").split("/")[1]
    end

    def current_song_artist
      current_song.nil? ? "" : current_song.file.gsub(".mp3", "").split("/")[0]
    end

    def stats
      @mpd.stats
    end

    def songs
      @mpd.songs
    end

    def song_by_file(file_path)
      begin
        @mpd.songs.each_with_index do |s, i|
          return s if s.file == file_path
        end
        return nil
      rescue
        return nil
      end
    end

    def queue
      @mpd.queue.sort_by &:pos
    end

    def queued_song_ids
      q = queue
      q.nil? ? nil : q.map { |s|
        s.file.gsub(".mp3", "")
      }
    end

    def queue_add(s)
      unless song_is_in_queue?(s)
        @mpd.add s
      end
      song_is_in_queue?(s)
    end

    def song_is_in_queue?(s)
      return false if s.nil?
      files_in_queue = @mpd.queue.map(&:file)
      return false if files_in_queue.nil?

      files_in_queue.each do |f|
        return true if f == s.file
      end
      return false
    end

    def queue_remove(s)
      @mpd.remove s
    end

    def queue_clear
      @mpd.clear
    end

    def update_song_list
      begin
        @mpd.update if @mpd.connected?
      rescue
        nil
      end
    end

    def volume(val=nil)
      return @mpd.volume if val.nil?
      @mpd.volume = val
    end
  end
end
