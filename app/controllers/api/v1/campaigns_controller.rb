class Api::V1::CampaignsController < ApplicationController

  def index
    @campaigns = Campaign.order(:created_at)
    #render json: @campaigns
  end

  def show
    campaign = Campaign.find params[:id]
    render json: campaign
  end
  
end
