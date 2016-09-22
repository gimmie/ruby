module GimmieAPI
  class Client
    attr_reader :uid

    def initialize(uid:)
      @uid = uid
    end

    def trigger(event_name, data)
      rest.post(events_url, event_name: event_name, event_data: data.to_json)
    end

    def user
      User.new(root, client: self).fetch
    end

    def follow_link(hal_link)
      hal_link.send(:new_resource_from_response, rest.get(hal_link.url))
    end

    def rest
      Faraday.new(builder: builder)
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

    def hal_root
      HyperResource.new(
        root: GimmieAPI.api_root+'/gm/',
        faraday_options: {
          builder: builder
        }
      )
    end

    def root
      @root ||= follow_link(hal_root.to_link)
    end

    def events_url
      root.events.url
    end
  end
end
