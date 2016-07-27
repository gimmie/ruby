require 'dotenv'
Dotenv.load

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gimmie_api'

require 'pry'
require 'rack/test'

GimmieAPI.client_key = ENV['CLIENT_KEY']
GimmieAPI.client_secret = ENV['CLIENT_SECRET']
