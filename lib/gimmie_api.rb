require 'faraday'
require 'faraday_middleware'
require 'faraday_middleware/request/oauth'
require 'json'
require 'hyperclient'
require 'hashie'

require 'gimmie_api/version'
require 'gimmie_api/client'
require 'gimmie_api/remote_resource'
require 'gimmie_api/remote_collection'
require 'gimmie_api/post_link'
require 'gimmie_api/user'
require 'gimmie_api/root'
require 'gimmie_api/owned_stamp_cards'
require 'gimmie_api/owned_points'
require 'gimmie_api/owned_rewards'
require 'gimmie_api/owned_reward_catalogs'

module GimmieAPI
  class << self
    attr_accessor :client_key, :client_secret, :api_root, :faraday_adapter
  end
end
