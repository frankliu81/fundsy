class NearbyCampaignsController < ApplicationController
  before_action :authenticate_user!

  def index
    coordinates = [ current_user.latitude, current_user.longitude]
    @campaigns = Campaign.near(coodinates, 40, units: :km)
    @markers = Gmap4rails.build_markers(@campaigns) do |campaign, marker|
      marker.lat campaign.latitude
      mark.lng campaign.longitude
      marker.infowindow campaign.title
    end
  end

end
