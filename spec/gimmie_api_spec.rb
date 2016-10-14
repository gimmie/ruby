require 'spec_helper'

class FakeEventServer
  def call(env)
    request = Rack::Request.new(env)
    case request.request_method
    when 'POST'
      if request.params['event_name'] == 'example_event'
        [201, {"Content-Type" => "application/json"}, [{"_embedded"=>{"item"=>[{name: 'message', message: 'U did it'}]}, "_links"=>{"curies"=>[{"name"=>"gm", "href"=>"http://gimmie.lvh.me:3000/doc/{rel}", "templated"=>true}]}}.to_json]]
      else
        [404, {"Content-Type" => "application/json"}, [{'error' => 'not found!'}.to_json]]
      end
    else
      [404, {}, [{"error" => "Did you get lost?"}.to_json]]
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
            map "/user/" do
              run lambda {|env| [200, {"Content-Type" => "application/json"}, [{"uid"=>"123456", "_embedded"=>{"owned_rewards"=>[], "owned_stamp_cards"=>[{"name"=>"somename", "provider_name"=>"provname", "current_stamp_count"=>5, "stamp_image_url"=>"https://gimmie2016-staging-images.herokuapp.com/view/54/eb/4f/b2/99/7b/de/7a/62/8e/84/2d/73/d1/b7/e2/50x50%23/8bit.png", "logo_image_url"=>"https://gimmie2016-staging-images.herokuapp.com/view/f3/95/50/dc/55/b3/40/27/67/ec/95/ac/f7/6c/b4/3a/200x200%23/Astrochicken.gif", "max_stamps"=>10, "store_locations"=>"locationnn", "expires_at"=>"2017-01-30T16:00:00.000Z", "expires_in_days"=>500, "_links"=>{"curies"=>[{"name"=>"gm", "href"=>"http://www.example.com/doc/{rel}", "templated"=>true}]}}]}, "_links"=>{"curies"=>[{"name"=>"gm", "href"=>"http://www.example.com/doc/{rel}", "templated"=>true}], "self"=>{"href"=>"http://www.example.com/gm/user/123456"}}}.to_json]] }
            end
            map "/events" do
              run FakeEventServer.new
            end
            map "/" do
              run lambda {|env| [200, {"Content-Type" => "application/json"}, [{"_links"=>{"curies"=>[{"name"=>"gm", "href"=>"http://www.example.com/doc/{rel}", "templated"=>true}], "self"=>{"href"=>"http://www.example.com/gm"}, "gm:user"=>{"href"=>"http://www.example.com/gm/user", "templated"=>true}, "gm:trigger_event"=>{"href"=>"http://www.example.com/gm/events"}, "swagger_doc"=>{"href"=>"http://www.example.com/gm/swagger_doc"}}}.to_json]] }
            end
          end
        end

        allow(GimmieAPI).to receive(:faraday_adapter).and_return([:rack, app])
        allow(GimmieAPI).to receive(:api_root).and_return('http://www.example.com')
      end
    end

    it 'sends an event and returns results' do
      client = GimmieAPI::Client.new(uid: 'some_uid')
      results = client.trigger('example_event', 'example_property_name' => 'example_property_value')
      expect(results.first.message).to eq 'U did it'
    end

    it 'raises not found for a misisng event' do
      client = GimmieAPI::Client.new(uid: 'some_uid')
      expect { client.trigger('bogus_event', 'example_property_name' => 'example_property_value') }.to raise_error(Faraday::ResourceNotFound)
    end

    it 'returns errors in the exception' do
      client = GimmieAPI::Client.new(uid: 'some_uid')
      begin
        client.trigger('bogus_event', 'example_property_name' => 'example_property_value')
      rescue Faraday::ClientError
        expect($!.response[:body]['error']).to eq 'not found!'
      end
    end
  end
end
