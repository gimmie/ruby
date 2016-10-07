module GimmieAPI
  class Client
    extend Forwardable

    def_delegators :root, :user, :trigger

    attr_reader :uid

    def initialize(uid:)
      @uid = uid
    end

    def root
      @root ||= Root.new(hal_root, client: self).fetch
    end

    def follow_link(hal_link)
      hal_link.send(:new_resource_from_response, rest.get(hal_link.url))
    end

    def resource_from_hal(json_hash)
      Hyperclient::Resource.new(json_hash, hal_root)
    end

    def rest
      Faraday.new(builder: ::Faraday::RackBuilder.new(&connection_proc))
    end

    # There's some bug with Hyperclient performing the POST, though GET works fine
    # May just be a problem in the test environment but easy enough to work around
    def post(link, params = {})
      resp = rest.post(link._url, params)
      resource_from_hal(resp.body)
    end

    private

    def hal_root
      Hyperclient.new(GimmieAPI.api_root+'/gm/') do |c|
        c.connection({default: false}, &connection_proc)
      end
    end

    def connection_proc
      Proc.new do |connection|
        #largely borrowed from - https://github.com/codegram/hyperclient/blob/7169b78f0685e6e8a7d9549b42079fb6d3d1a66e/lib/hyperclient/entry_point.rb#L126
        connection.use Faraday::Response::RaiseError
        connection.use FaradayMiddleware::FollowRedirects
        #connection.request :hal_json # Not certain what a hal request is, as opposed to a response, but it makes things not work so out it goes
        connection.request :url_encoded
        connection.request :oauth,
          consumer_key: GimmieAPI.client_key,
          consumer_secret: GimmieAPI.client_secret,
          token: uid,
          token_secret: GimmieAPI.client_secret
        connection.response :hal_json, content_type: /\bjson$/

        if GimmieAPI.faraday_adapter
          connection.adapter *GimmieAPI.faraday_adapter
        else
          connection.adapter Faraday.default_adapter
        end
      end
    end
  end
end
