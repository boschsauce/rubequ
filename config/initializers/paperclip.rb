Paperclip.interpolates :song_name do |attachment, style|
  "#{attachment.instance.name}".downcase
end

Paperclip.interpolates :file_path do |attachment, style|
  "#{attachment.instance.band}".gsub(" ", "_").downcase.gsub(/[^0-9a-z]/, '')
end

Paperclip.interpolates :custom_filename do |attachment, style|
  "#{attachment.instance.name.gsub(" ", "_").downcase.gsub(/[^0-9a-z]/, '')}.mp3"
end
