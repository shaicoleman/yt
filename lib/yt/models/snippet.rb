require 'yt/models/description'

module Yt
  module Models
    # @private
    # Provides methods to interact with the snippet of YouTube resources.
    # @see https://developers.google.com/youtube/v3/docs/channels#resource
    # @see https://developers.google.com/youtube/v3/docs/videos#resource
    # @see https://developers.google.com/youtube/v3/docs/playlists#resource
    # @see https://developers.google.com/youtube/v3/docs/playlistItems#resource
    class Snippet < Base
      attr_reader :data

      def initialize(options = {})
        @data = options[:data]
        @auth = options[:auth]
      end

      has_attribute :title, default: ''
      has_attribute(:description, default: '') {|text| Description.new text}
      has_attribute :published_at, type: Time
      has_attribute :updated_at, type: Time
      has_attribute :channel_id
      has_attribute :video_id
      has_attribute :channel_title
      has_attribute :tags, default: []
      has_attribute :category_id
      has_attribute :live_broadcast_content
      has_attribute :playlist_id
      has_attribute :position, type: Integer
      has_attribute :resource_id, default: {}
      has_attribute :thumbnails, default: {}

      def thumbnail_url(size = :default)
        thumbnails.fetch(size.to_s, {})['url']
      end

      # Returns whether YouTube API includes all attributes in this snippet.
      # For instance, YouTube API only returns tags and categoryId on
      # Videos#list, not on Videos#search. And returns position on
      # PlaylistItems#list, not on PlaylistItems#insert.
      # This method is used to guarantee that, when a video was instantiated
      # by one of the methods above, an additional call to is made to retrieve
      # the full snippet in case an attribute is missing.
      # @see https://developers.google.com/youtube/v3/docs/videos
      # @return [Boolean] whether YouTube API includes the complete snippet.
      def complete?
        @complete ||= data.fetch :complete, true
      end
    end
  end
end
