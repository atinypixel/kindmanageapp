# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_kindmanage_session',
  :secret      => 'f6317a8af42e17a8234b5949f19f141a5bf9d8a6d643be8eb39b21b34b159f7d158591222dbf4319dfef16036084337bf60fde93e611f39ceb6a9cf902472008'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
