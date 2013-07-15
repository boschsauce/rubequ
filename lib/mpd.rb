
require 'ruby-mpd'

class Mpd
  attr_accessor :mpd

  def initialize(address)
    @mpd = MPD.new address, 6600
    connect
  end

  def connect
    begin
      @mpd.connect 
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

  def queue_add(s)
    unless song_is_in_queue?(s)
      @mpd.add s
    end
    song_is_in_queue?(s)
  end

  def song_is_in_queue?(s)
    return false if s.nil?
    @mpd.queue.include?(s) 
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
end

=begin

m = Mpd.new("127.0.0.1")
m.connect


m.play
=end

=begin
playlist = m.rasplay_playlist

puts m.songs.inspect

s = m.song_by_file("flyleaf/imsosick.mp3")
m.queue_add(s)

s = m.song_by_file("beyonce/crazyinlove.mp3")
m.queue_add(s)

m.play
=end

#puts m.queue_add(song)

#m.queue_clear







=begin
m.update_song_list

puts m.songs.inspect

puts m.playlists.inspect

#s = m.song_by_file("alanjackson/rightonthemoney.mp3")


#p = m.new_playlist("rasplay")
#p.add s
puts m.playlists.first.songs.inspect

s = m.playlists.first.songs.first
puts "SONG:#{s.inspect}"

p = m.playlists.first
m.play
song = m.current_song
unless song.nil?
  puts "SONG:#{song.inspect}"
  puts "Band/Artist:#{m.current_song_artist}"
  puts "Song:#{m.current_song_name}"
end
m.disconnect

=end


