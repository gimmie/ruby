module GimmieAPI
  class RemoteCollection < RemoteResource
    def data
      resource._embedded.to_h.values.first.map(&:_attributes)
    end
  end
end
