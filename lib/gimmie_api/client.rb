module GimmieAPI
  class Client
    attr_reader :uid

    def initialize(uid:)
      @uid = uid
    end

    def trigger(event_name, data)
      uri = URI.parse(GimmieAPI.api_root)
      uri.path = '/gm/events'
      rest.post(uri.to_s, event_name: event_name, event_data: data.to_json)
    end

    private

    def builder
      ::Faraday::RackBuilder.new do |builder|
        builder.request :url_encoded
        builder.request :oauth,
          consumer_key: GimmieAPI.client_key,
          consumer_secret: GimmieAPI.client_secret,
          token: uid,
          token_secret: GimmieAPI.client_secret

        if GimmieAPI.faraday_adapter
          builder.adapter *GimmieAPI.faraday_adapter
        else
          builder.adapter Faraday.default_adapter
        end
      end
    end

    def rest
      Faraday.new(builder: builder)
    end
  end
end
