class CampaignsController < ApplicationController

  before_action :find_campaign, only: [:show, :edit, :update, :destroy]

  def new
      @campaign = Campaign.new
  end

  def create

    # campaign_params is now a method
    #campaign_params = params.require(:campaign).permit(:title, :body, :goal, :end_date)
    @campaign = Campaign.new(campaign_params)

    if @campaign.save
      redirect_to campaign_path(@campaign), notice: "Campaign created!"
    else
      flash[:alert] = "Campaign not created!"
      render :new
    end

    # empty 200 response
    #render nothing: true
  end

  def show
  end

  def index
    # @campaigns = Campaign.order(:created_at).all
    @campaigns = Campaign.all
  end

  def edit
  end

  def update
    if @campaign.update campaign_params
      redirect_to campaign_path(@campaign), notice: "Updated!"
    else
      render :edit
    end
  end

  def destroy
    @campaign.destroy
    redirect_to campaigns_path, notice: "Deleted!"
  end

  private

  def find_campaign
    @campaign = Campaign.find params[:id]
  end

  def campaign_params
    # require make sure there is a key :campaign
    campaign_params = params.require(:campaign).permit(:title, :body, :goal, :end_date)
  end

end
