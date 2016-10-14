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
user_data.uid # => 'newuser'
user_data.to_h # => {"uid"=>"newuser", "created_at"=>"2016-10-14T06:12:51.098Z", "properties"=>[]}
```

### Retrieving owned Rewards which have not been redeemed

```ruby
owned_rewards = GimmieAPI::Client.new(uid: uid).user.owned_rewards.data
owned_rewards.first.name # => "Doloribus sunt sit quia."
owned_rewards.to_h # => {"name"=>"Doloribus sunt sit quia.", "reward_id"=>1, "redemption_url"=>"...", "description"=>"Et voluptas maxime sunt illum et ratione sed consequatur."}
```

### Retrieving reward catalogs available to the User

```ruby
reward_catalogs = GimmieAPI::Client.new(uid: uid).user.owned_reward_catalogs.data
reward_catalogs.first.name # => "some reward catalog name"
purchasable_rewards = reward_catalogs.first.purchasable_rewards
purchasable_rewards.first.name # => "some reward name"
reward_prices = purchasable_rewards.first.reward_prices
reward_price = reward_prices.first
reward_price.name # => "some points program name"


# to purchase a reward for a user using points:
begin
  new_owned_reward = reward_price.purchase_link.post
rescue Faraday::ClientError
  purchase_failure_reason = $!.response[:body]['error']
end
```

### Retrieving stamp cards owned by the User

```ruby
stamp_cards = GimmieAPI::Client.new(uid: uid).user.owned_stamp_cards.data
stamp_cards.first.name # => 'some stamp card name'
stamp_cards.first.to_h # => {"name"=>"Consequatur eos rerum deserunt voluptas.", "provider_name"=>"Ut suscipit ab sit eos a expedita culpa.", "current_stamp_count"=>3, "max_stamps"=>10}
```

### Retrieving points programs that have points assigned to the User

```ruby
owned_points = GimmieAPI::Client.new(uid: uid).user.owned_points.data
owned_points.first.name # => 'some points program name'
owned_points.first.to_h # => {"assigned_points"=>10, "remaining_points"=>10, "points_program_name"=>"Rerum repellat autem iste deleniti dolorem repellendus autem nobis."}
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

