module GimmieAPI
  class RemoteResource
    def initialize(link, client:)
      @link = link
      @client = client
    end

    def resource
      @resource
    end

    # Overwrite me for arrays, etc
    def data
      resource._attributes
    end

    def fetch
      @resource = @link._get
      self
    end

    def follow_link_to_resource(resource_link, resource_class)
      resource_class.new(resource_link, client: @client).fetch
    end
  end
end
