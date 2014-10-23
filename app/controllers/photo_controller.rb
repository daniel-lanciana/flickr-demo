require 'flickraw'

=begin
Size Suffixes

The letter suffixes are as follows:

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

# Move?
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

class PhotoController < ApplicationController
  def index
    @results = []
  end

  # move to helper class?
  def search
    FlickRaw.api_key    = '4665ef6fd72427931c8c09129cd44b5d'
    FlickRaw.shared_secret = '4dfa5ab177cb4971'
    # :page => params[:page] || 1
    #results = flickr.photos.search(:tags => 'cats', :per_page => 5, :page => 1).each do |photo|
    #info = flickr.photos.getInfo(:photo_id => photo.id)

    #puts 'https://farm' + photo.farm.to_s + '.staticflickr.com/' + photo.server.to_s + '/' + photo.id.to_s + '_' + photo.secret + '_t.jpg'
    #puts photo.url_t

    #thumb = FlickRaw.url_t(info)
    #puts thumb
    #large = FlickRaw.url_b(info)
    #puts large
    #puts ''
    #end

    #puts 'page = ' + params[:page]

    # searching nothing not allowed
    if params[:search_input].to_s.strip.empty?
      flash[:error_msg] = "Please enter some text to search for..."
      @results = []
    else
      @results = flickr.photos.search(:tags => params[:search_input], :per_page => 5, :page => params[:page] || 1)
    end
  end
end
