module GimmieAPI
  class PostLink
    def initialize(link, client:)
      @link = link
      @client = client
    end

    def post
      Hashie::Mash.new(@client.post(@link)._attributes.to_h)
    end
  end
end
