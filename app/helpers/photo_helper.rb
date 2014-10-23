module PhotoHelper
  class FlickRaw::Response
    def url_t
      'https://farm' + self.farm.to_s + '.staticflickr.com/' + self.server.to_s + '/' + self.id.to_s + '_' + self.secret + '_t.jpg'
    end
  end
end
