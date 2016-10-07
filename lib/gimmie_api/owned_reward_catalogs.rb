module GimmieAPI
  class OwnedRewardCatalogs < RemoteCollection
    def data
      resource.item.map do |reward_catalog|
        prs = reward_catalog['gm:purchasable_rewards'].item.map do |pr|
          reward_prices = pr['gm:reward_prices'].item.map do |rp|
            rp._attributes.to_h.merge(
              purchase_link: PostLink.new(rp['gm:purchase_reward'], client: @client)
            )
          end
          pr._attributes.to_h.merge(reward_prices: reward_prices)
        end
        rc_data = {
          'purchasable_rewards' => prs
        }.merge(reward_catalog._attributes.to_h)
        Hashie::Mash.new(rc_data)
      end
    end
  end
end
