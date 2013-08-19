class Comment < ActiveRecord::Base
  belongs_to :song

  validates_presence_of :comment_text 
end
