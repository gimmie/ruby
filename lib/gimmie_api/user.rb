module GimmieAPI
  class User

    def initialize(root, client:)
      @root = root
      @client = client
    end

    def fetch
      @user = @client.follow_link(@root.user)
      self
    end

    def owned_stamp_cards
      @user.owned_stamp_cards
    end

    def owned_rewards
      @user.owned_rewards
    end
  end
end
