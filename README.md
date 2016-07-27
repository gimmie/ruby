# GimmieAPI

Ruby wrapper for the Gimmie API. Currently only sending events are supported.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gimmie_api', github: 'gimmie/ruby'
```

And then execute:

    $ bundle

Set the client key, secret, and api url by doing:

```ruby
GimmieAPI.client_key = 'yourclientkey'
GimmieAPI.client_secret = 'yourclientsecret'
GimmieAPI.api_root = 'http://instancename.gimmie.io' # replace instancename with your instance name
```

Optionally, you can change the Faraday adapter, by default it is:

```ruby
GimmieAPI.faraday_adapter = Faraday.default_adapter
```

Which should work just fine for most use cases but if you have a special use case, see the Faraday documentation.

## Usage

See the specs for examples, but basically:

```ruby
response = GimmieAPI::Client.new(uid: uid).trigger('name_of_event', {'user_property_name' => 'user_property_value', ...})
response.success? # basic faraday response object
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

