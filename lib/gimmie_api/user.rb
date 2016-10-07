module GimmieAPI
  class User < RemoteResource
    def owned_stamp_cards
      follow_link_to_resource(resource['gm:owned_stamp_cards'], OwnedStampCards)
    end

    def owned_rewards
      follow_link_to_resource(resource['gm:owned_rewards'], OwnedRewards)
    end

    def owned_points
      follow_link_to_resource(resource['gm:owned_points'], OwnedPoints)
    end

    def owned_reward_catalogs
      follow_link_to_resource(resource['gm:owned_reward_catalogs'], OwnedRewardCatalogs)
    end
  end
end
