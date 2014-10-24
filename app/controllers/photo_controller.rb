require 'flickraw'

=begin
Flickr image size suffix notation:

s	small square 75x75
q	large square 150x150
t	thumbnail, 100 on longest side
m	small, 240 on longest side
n	small, 320 on longest side
-	medium, 500 on longest side
z	medium 640, 640 on longest side
c	medium 800, 800 on longest side
b	large, 1024 on longest side
h	large 1600, 1600 on longest side
k	large 2048, 2048 on longest side
=end
class FlickRaw::Response
  def url_q
    build_img_url.gsub('?', 'q')
  end

  def url_c
    build_img_url.gsub('?', 'c')
  end

  def build_img_url
    "https://farm#{self.farm}.staticflickr.com/#{self.server}/#{self.id}_#{self.secret}_?.jpg"
  end
end

# Main controller for the application. Handles searches and results.
class PhotoController < ApplicationController
  # Home page with no results
  def index
    @results = []
  end

  # Search Flickr for photos
  def search
    # Searching nothing throws an exception with the gem
    if params[:search_input].to_s.strip.empty?
      # Once-off error message -- need to use .now
      flash.now[:error_msg] = "Please enter some text to search for..."
      @results = []
    else
      # Read from the cache
      @results = Rails.cache.read(params[:search_input])

      # If API results are not currently in the cache
      if @results == nil
        @results = []

        # Only need to initialise when calling the API
        FlickRaw.api_key = Rails.application.secrets.flickr_api_key
        FlickRaw.shared_secret = Rails.application.secrets.flickr_shared_secret

        # API call results from Flickr then add to an Array so we can paginate
        flickr.photos.search(:tags => params[:search_input], :per_page => 100).each do |a|
          @results << a
        end

        # Write to the cache to speed up future requests/pagination
        Rails.cache.write(params[:search_input], @results)
      else
        logger.info "Getting cached Flicker API results for: #{params[:search_input]}"
      end

      # Paginate and make instance variable available in the view
      @results = @results.paginate(:page => params[:page], :per_page => 8)
    end
  end
end
