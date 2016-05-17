class Api::V1::CampaignsController < Api::BaseController

  def create
    campaign = Campaign.new(campaign_params)
    campaign.user = @user
    if campaign.save
      render json: campaign
    else
      render json: {errors: campaign.errors.full_messages }
    end
  end

  def index
    @campaigns = Campaign.order(:created_at)
    #render json: @campaigns
  end

  def show
    campaign = Campaign.find params[:id]
    render json: campaign
  end

  def campaign_params
    params.require(:campaign).permit(:title, :body, :goal, :end_date)
  end

end
