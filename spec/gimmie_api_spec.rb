require 'spec_helper'

class FakeEventServer
  def call(env)
    request = Rack::Request.new(env)
    case request.request_method
    when 'POST'
      if request.params['event_name'] == 'example_event'
        [201, {"Content-Type" => "application/json"}, [{}.to_json]]
      else
        [404, {"Content-Type" => "application/json"}, [{}.to_json]]
      end
    else
      [404, {}, ["Did you get lost?"]]
    end
  end
end

describe GimmieAPI do
  it 'has a version number' do
    expect(GimmieAPI::VERSION).not_to be nil
  end

  describe 'sending events' do
    before do
      if ENV['LIVE_SERVER']
        allow(GimmieAPI).to receive(:api_root).and_return(ENV['LIVE_SERVER'])
      else
        app = Rack::Builder.new do
          map "/gm" do
            map "/events" do
              run FakeEventServer.new
            end
          end
        end

        allow(GimmieAPI).to receive(:faraday_adapter).and_return([:rack, app])
        allow(GimmieAPI).to receive(:api_root).and_return('http://www.example.com')
      end
    end

    it 'sends an event successfully' do
      client = GimmieAPI::Client.new(uid: 'some_uid')
      resp = client.trigger('example_event', 'example_property_name' => 'example_property_value')
      expect(resp.status).to eq 201
    end
  end
end
