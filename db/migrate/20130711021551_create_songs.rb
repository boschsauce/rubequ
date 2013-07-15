class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name
      t.string :band
      t.string :album
      t.string :album_cover
      t.datetime :release_date

      t.timestamps
    end
  end
end
