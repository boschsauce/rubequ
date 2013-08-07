require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the RootHelper. For example:
#
# describe RootHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe SongsHelper do
  describe "time ago in words with blank" do
    it "should retun a empty message string when datetime value is blank" do
      helper.time_ago_in_words_with_blank(nil, "").should eq ""
    end

    it "should return a custom message string when datetime value is blank" do
      helper.time_ago_in_words_with_blank(nil, "No date has been entered.").should eq "No date has been entered."
    end

    it "returns time_ago_in_words with the provided datetime value" do
      helper.time_ago_in_words_with_blank(2.days.ago).should eq "2 days"
    end
  end
end
