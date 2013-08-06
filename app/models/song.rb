class Song < ActiveRecord::Base

  if(Rails.env.test? || Rails.env.development?)
    has_attached_file :mp3, :path => "public/music/:custom_filename"
  end

  validates_presence_of :name,
                        :band,
                        :mp3

  before_create :set_album_cover

  default_scope { order('created_at DESC') }

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

  def self.by_file(file)
    Song.all.find { |s| s.mp3.path.gsub("public/music/", "") == file } unless file.blank?
  end

  def set_album_cover
    song_info = RubequSongInformation::AlbumCover.new
    self.album_cover = song_info.get_cover(self.band_and_song_name_formatted)
  end

  def lyrics
    {
      :lyrics => RubequSongInformation::Lyrics.new.get_lyrics(self.band, self.name)
    }
  end

  def in_queue?
    mpd = RubequMpd::Mpd.new
    mpd.update_song_list
    song = mpd.song_by_file(self.mp3.path.gsub("public/music/", ""))
    result = song.nil? ? false : mpd.song_is_in_queue?(song)
    mpd.disconnect
    result
  end

  def add_to_queue
    mpd = RubequMpd::Mpd.new
    song = mpd.song_by_file(self.mp3.path.gsub("public/music/", ""))
    result = mpd.queue_add(song)
    mpd.play if mpd.current_song.nil?
    mpd.disconnect
    result
  end

  def self.all_in_queue
    mpd = RubequMpd::Mpd.new
    queued_song_ids = mpd.queued_song_ids
    current_song_id = mpd.current_song_id
    mpd.disconnect

    queued_song_ids.delete(current_song_id)
    Song.unscoped.where(:id => queued_song_ids)
  end

  def self.current_song
    mpd = RubequMpd::Mpd.new
    song = mpd.current_song
    mpd.disconnect
    song.blank? ? nil : Song.by_file(song.file)
  end

  def self.play
    mpd = RubequMpd::Mpd.new
    mpd.play
    mpd.disconnect
  end

  def self.pause
    mpd = RubequMpd::Mpd.new
    mpd.pause
    mpd.disconnect
  end

  def self.next
    mpd = RubequMpd::Mpd.new
    mpd.next
    mpd.disconnect
  end
end
