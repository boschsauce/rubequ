# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
#https://github.com/gedankenstuecke/snpr/blob/master/config/initializers/secret_token.rb
#execute in the project root. 
#rake secret > secret_token
begin 
  token_file = Rails.root.to_s + "/secret_token"
  to_load = open(token_file).read
  Rubequ::Application.configure do
    config.secret_token = to_load
  end
rescue LoadError, Errno::ENOENT => e
  raise "Secret token couldn't be loaded! Error: #{e}"
end
