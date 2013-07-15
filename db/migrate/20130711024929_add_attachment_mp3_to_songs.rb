class AddAttachmentMp3ToSongs < ActiveRecord::Migration
  def self.up
    change_table :songs do |t|
      t.attachment :mp3
    end
  end

  def self.down
    drop_attached_file :songs, :mp3
  end
end
