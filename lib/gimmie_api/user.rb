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

    def stamp_cards
      @user.owned_stamp_cards
    end
  end
end
