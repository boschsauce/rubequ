# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :song do
    name "I'm Sexy And I Know It"
    band "LMAFO"
    album "Sorry For Party Rocking"
    album_cover "http://a5.mzstatic.com/us/r1000/086/Features/1f/76/c9/dj.uqxkqdqp.170x170-75.jpg"
    release_date "2011-06-21 00:00:00"
    mp3 File.new(Rails.root + 'spec/factories/music/ImSexyAndIKnowIt.mp3')
  end
end
