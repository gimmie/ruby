module GimmieAPI
  class Root < RemoteResource
    def user
      follow_link_to_resource(resource['gm:user'], User)
    end

    def trigger(event_name, data)
      results = @client.post(resource['gm:trigger_event'], event_name: event_name, event_data: data.to_json)
      results.item.map{|r| Hashie::Mash.new(r._attributes.to_h) }
    end
  end
end
