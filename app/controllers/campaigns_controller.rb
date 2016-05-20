class CampaignsController < ApplicationController

  before_action :find_campaign, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index]

  def new
      @campaign = Campaign.new
      3.times { @campaign.rewards.build }
  end

  def create

    # campaign_params is now a method
    #campaign_params = params.require(:campaign).permit(:title, :body, :goal, :end_date)
    @campaign = Campaign.new(campaign_params)
    @campaign.user = current_user

    if @campaign.save
        CampaignGoalJob.set(wait_until: @campaign.end_date).perform_later(@campaign)
      redirect_to campaign_path(@campaign), notice: "Campaign created!"
    else
      gen_count = 3 - @campaign.rewards.size
      gen_count.times { @campaign.rewards.build }
      # 3.times { @campaign.rewards.build }
      flash[:alert] = "Campaign not created!"
      render :new
    end

    # empty 200 response
    #render nothing: true
  end

  def show
  end

  def index
    # database may order the return record differently, making test fails
    @campaigns = Campaign.order(:created_at)
    respond_to do |format|
      # note that render json: will automatically call .to_json method to the argument
      format.json { render json: @campaigns.to_json }
      format.html { render }
    end

    #@campaigns = Campaign.all

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
    campaign_params = params.require(:campaign).permit(:title, :body, :goal, :end_date, :address, {rewards_attributes: [:amount, :description, :id, :_destroy]})
  end


end
