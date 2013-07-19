require 'mpd'

class Song < ActiveRecord::Base

  if(Rails.env.test? || Rails.env.development?)
    has_attached_file :mp3, :path => "public/music/:file_path/:custom_filename"
  end

  validates_presence_of :name,
                        :band,
                        :mp3

  before_create :set_album_cover

  default_scope order('created_at DESC')

  def as_json(options={})
    {
      :id           => self.id,
      :album        => self.album,
      :album_cover  => self.album_cover,
      :band         => self.band,
      :name         => self.name,
      :release_date => self.release_date_formatted,
      :mp3_path     => self.mp3_public_path,
      :in_queue     => self.in_queue?
    }
  end

  def mp3_public_path
    self.mp3.blank? ? "" : self.mp3.path.gsub!("public", "")
  end

  def release_date_formatted
    self.release_date.blank? ? "" : self.release_date.strftime("%m/%d/%Y")
  end

  def band_and_song_name_formatted
    self.band + " " + self.name
  end

  def set_album_cover
    song_info = SongInformation::AlbumCover.new
    self.album_cover = song_info.get_cover(self.band_and_song_name_formatted)
  end

  def lyrics
    {
      :lyrics => SongInformation::Lyrics.new.get_lyrics(self.band, self.name)
    }
  end

  def in_queue?
    @mpd = Mpd.new("127.0.0.1")
    @mpd.update_song_list
    song = @mpd.song_by_file(self.mp3.path.gsub("public/music/", ""))
    result = song.nil? ? false : @mpd.song_is_in_queue?(song)
    @mpd.disconnect
    result
  end

  def self.all_in_queue
    @mpd = Mpd.new("127.0.0.1")
    return nil unless @mpd.connected?
    queued_songs = @mpd.queue
    current_song = @mpd.current_song
    @mpd.disconnect

    songs = []
    song_db = Song.all
    queued_songs.each do |qs|
      song = song_db.find { |s| s.mp3.path.include?(qs.file) }
      if !song.blank? && !song.mp3.path.include?(current_song.file)
        songs << song
      end
    end
    songs
  end

  def self.current_song
    @mpd = Mpd.new("127.0.0.1")
    return nil unless @mpd.connected?
    song = @mpd.current_song
    @mpd.disconnect
    return nil if song.blank?
    Song.all.find { |s| s.mp3.path.include?(song.file) }
  end

  def add_to_queue
    @mpd = Mpd.new("127.0.0.1")
    song = @mpd.song_by_file(self.mp3.path.gsub("public/music/", ""))
    result = @mpd.queue_add(song)
    @mpd.disconnect
    return result
  end

  def self.play
    @mpd = Mpd.new("127.0.0.1")
    @mpd.play
    @mpd.disconnect
  end

  def self.pause
    @mpd = Mpd.new("127.0.0.1")
    @mpd.pause
    @mpd.disconnect
  end

  def self.next
    @mpd = Mpd.new("127.0.0.1")
    @mpd.next
    @mpd.disconnect
  end
end
