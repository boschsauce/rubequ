# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    comment_text "I love this song!"
    enabled true
  end
end
