require 'gimmie_api/version'
require 'gimmie_api/client'

require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/request/oauth'
require 'json'

module GimmieAPI
  class << self
    attr_accessor :client_key, :client_secret, :api_root, :faraday_adapter
  end
end
