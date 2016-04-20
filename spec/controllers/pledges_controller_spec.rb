require 'rails_helper'

RSpec.describe PledgesController, type: :controller do

  let(:campaign) { FactoryGirl.create(:campaign) }
  let(:user) { FactoryGirl.create(:user) }
  # equivalent for let
  # def campaign
  #   @campaign ||= FactoryGirl.create(:campaign)
  # end

  describe "#new" do
    context "without a signed in user" do
      # when we actually create a session controller
      # then we would redirect them to the sign in page

      # whats the URL for pledge, we need a campagin id
      it "redirects to sign up page" do
        # campaign.id is obtained from the leg
        get :new, campaign_id: campaign.id
        expect(response).to redirect_to new_user_path
      end

    end
    context "with a signed in user" do
      # request is the request object that rspec uses to interact
      # with the controller
      # we set the session[:user_id] to a valid user id to emulate user
      # being signed in
      before { request.session[:user_id] = user.id }
      it "renders the new template" do
        get :new, campaign_id: campaign.id
        expect(response).to render_template(:new)
      end
      it "assigns a new pledge instance variable" do
        get :new, campaign_id: campaign.id
        expect(assigns(:pledge)).to be_a_new(Pledge)
      end
    end
  end

  describe "#create" do

  end

end
