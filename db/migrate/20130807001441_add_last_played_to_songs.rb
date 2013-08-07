class AddLastPlayedToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :last_played, :datetime
  end
end
