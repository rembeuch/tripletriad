SimpleTokenAuthentication.configure do |config|
  config.sign_in_token = true
  config.header_names = { player: { authentication_token: 'X-Player-Token', email: 'X-Player-Email' } }
end
