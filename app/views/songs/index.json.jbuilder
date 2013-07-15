json.array!(@songs) do |song|
  json.extract! song, :name, :band, :album, :album_cover, :release_date
  json.url song_url(song, format: :json)
end
