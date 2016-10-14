# GimmieAPI

Ruby wrapper for the Gimmie API.

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

See the specs for examples on initialization and configuration. The basic usage including error handling is:

```ruby
begin
  event_results = GimmieAPI::Client.new(uid: uid).trigger('name_of_event', {'user_property_name' => 'user_property_value'})
rescue Faraday::ClientError
  puts $!.response[:body]['error']
end
```

### Sending Events

```ruby
event_results = GimmieAPI::Client.new(uid: uid).trigger('name_of_event', {'user_property_name' => 'user_property_value'})
```

### Retrieving User data

```ruby
user_data = GimmieAPI::Client.new(uid: uid).user.data
```

### Retrieving owned Rewards which have not been redeemed

```ruby
owned_rewards = GimmieAPI::Client.new(uid: uid).user.owned_rewards.data
```

### Retrieving reward catalogs available to the User

```ruby
reward_catalogs = GimmieAPI::Client.new(uid: uid).user.owned_reward_catalogs.data
```

### Retrieving stamp cards owned by the User

```ruby
stamp_cards = GimmieAPI::Client.new(uid: uid).user.owned_stamp_cards.data
```

### Retrieving points programs that have points assigned to the User

```ruby
stamp_cards = GimmieAPI::Client.new(uid: uid).user.owned_points.data
```

### Reloading the data in a resource

```ruby
stamp_cards_resource = GimmieAPI::Client.new(uid: uid).user.owned_points
stamp_cards = stamp_cards_resource.data
# time passes and stamp cards change
stamp_cards_resource.fetch
stamp_cards = stamp_cards_resource.data
# or more concisely
stamp_cards = stamp_cards_resource.fetch.data
```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

