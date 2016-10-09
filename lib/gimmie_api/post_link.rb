module GimmieAPI
  class PostLink
    def initialize(link, client:)
      @link = link
      @client = client
    end

    def post
      Hashie::Mash.new(@client.post(@link)._attributes.to_h)
    end

    def to_h
      {'url' => @link._url}
    end
    alias_method :to_hash, :to_h

    def to_s
      to_h.to_s
    end
  end
end
