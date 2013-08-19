require 'spec_helper'

describe Comment do
  before(:each) do
    @comment = stub_model(Comment, :comment_text => "This is amazing")
  end

  it "should validate that comment_text has a value" do
    @comment.comment_text = ""
    @comment.should have(1).error_on(:comment_text)
  end
end
