module SongsHelper
  def time_ago_in_words_with_blank(datetime, message="")
    datetime.blank? ? message : time_ago_in_words(datetime)
  end
end
