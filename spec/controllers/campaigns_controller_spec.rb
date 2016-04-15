require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do

  # shortcut for memoization
  let(:campaign) { FactoryGirl.create(:campaign)}
  # make use of memoization
  # def campaign
  #   # if @campaign is nil it will call FactoryGirl.create(:campaign)
  #   # otherwise it will just return @campaign
  #   # the first time it's called, it will create it, the second time
  #   # it will return the same thing
  #   @campaign ||= FactoryGirl.create(:campaign)
  # end

  # if you want to force creating a campaign then you can use:
  # let!(:campaign) {Factory.create(:campaign)}

  # mimic the new action
  # convention to put a pound before any action
  describe "#new" do
    before {get :new}
    # before do
    #   get :new
    # end

    it "renders the new template" do
      # Rails know :new is from Campaign, because of describe CampaignController
      # response is an object that RSpec provides us that will contain the
      # controller reponse data which will help us test things such as
      # rendering templates or directing to a specific page
      # render_template is a mather from rspec-rails to test rendering a specific
      # Rails template
      expect(response).to render_template(:new)
    end

    it "assigns a campaign object" do
      expect(assigns(:campaign)).to be_a_new(Campaign)
    end

  end

  describe '#create' do

    describe "with valid attributes" do

      # methods defined with in 'describe' are only available to examples
      # defined within the same describe (also applies to 'context')
      def valid_request
        # post :create, campaign: {title: "abc", goal: 100, body: "123"}
        post :create, campaign: FactoryGirl.attributes_for(:campaign)
      end


      it "saves a record to the database" do
        # rails mechanism to invoke a post to the controller
        # you need to send the parameters as hash
        # id gets created
        # key is the model name
        # printing the params hash, the hash follows rails convention
        count_before = Campaign.count
        valid_request
        count_after = Campaign.count
        # we assume we are starting with a clean database
        # if we want it to work, even if we have things in the database
        # every it has a begin/rollback, if you need multiple data, you have
        # to create them every test for every scenario

        expect(count_after).to eq(count_before + 1)
      end

      it "redirects to the campaign's show page" do
        valid_request
        # Campaign.last is the last campaign in the database
        expect(response).to redirect_to(campaign_path(Campaign.last))
      end

      it "sets a flash message" do
        valid_request
        # we actually have access to the flash
        # to be means exist, be meaning it's not nil, be is a matcher method
        # if you run it without implementation, expected nil to evaluate to true
        expect(flash[:notice]).to be
      end

    end

    describe "with invalid attributes" do

      def invalid_request
        post :create, campaign: {goal: 100, body: "123"}
      end

      # 'it' is run as a test example
      it "renders the new template" do
        invalid_request
        expect(response).to render_template(:new)
      end

      it "sets an alert message" do
        invalid_request
        expect(flash[:alert]).to be
      end

      it "doesn't save a record to the database" do
        count_before = Campaign.count
        invalid_request
        count_after = Campaign.count
        expect(count_after).to eq(count_before)
        # you can comment out validation to make the test fail first

      end

    end

  end

  describe "#show" do

    before do
      # @c = Campaign.create(title: "valid title", goal: 123)
      # @c = FactoryGirl.create(:campaign)
      # get :show, id: @c.id

      # make use of memoization
      get :show, id: campaign.id
    end

    it "renders the show template" do
      # you have to be given a record in the database
      expect(response).to render_template(:show)

    end

    it "sets a campaign instance variable" do
      # how do you test @campaign
      # you can do Campaign.last but it will do another query
      # which takes time
      # assigns check inside your new action, that you have made
      # a new variable calls @campaign
      # expect(assigns(:campaign)).to eq(@c)

      # make use of memoization
      expect(assigns(:campaign)).to eq(campaign)
    end
  end

  describe "#index" do

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    # for simplicity, in real life, you will do pagination
    it "assigns an instance variable to all campaigns in the DB" do
      # given, there are at least two campaigns
      c = FactoryGirl.create(:campaign)
      c1 = FactoryGirl.create(:campaign)
      # when, we call a get :index
      get :index
      # then, we have instance variable that contains those two campaigns
      # expect(assigns(:campaigns)).to be_a_new()

      # Campaigns.all returns ActiveRecord::Relation
      # behaves like an array

      # assigns would look for instance variable @campaigns
      expect(assigns(:campaigns)).to eq([c, c1])

    end


  end

  describe "#edit" do

    it "renders the edit template" do
      get :edit, id: campaign.id
      expect(response).to render_template(:edit)
    end

    it "sets an instance variable with the passed id" do
      # campaigns # this cal is redundant, since campaign.id will call campaign
      get :edit, id: campaign.id
      # assigns(:campaign) is an instance variable
      # campaign is a local variable
      # byebug
      expect(assigns(:campaign)).to eq(campaign)
    end



  end

  describe "#update" do
    describe "with valid params" do

      # new_valid_body is only available within the describe
      let(:new_valid_body) { Faker::ChuckNorris.fact}
      # def valid_request
      before do
        # we need to give an id to update a record in the database
        patch :update, id: campaign.id, campaign: {body: new_valid_body}
      end

      it "updates the record whose id is passed" do
        # given, something to update


        # one gotcha, campaign in here, you need .reload to fetch
        # the update from the database into the rspec instance
        # since the update was made via the controller instance
        expect(campaign.reload.body).to eq(new_valid_body)

      end

      it "redirects to the show page" do
        expect(response).to redirect_to(campaign_path(campaign))
      end

      it "sets a flash notice message" do
        # check not be nil
        # otherwise to not_be
        expect(flash[:notice]).to be
      end

    end

    describe "with invalid params" do
      before do
        # we need to give an id to update a record in the database
        patch :update, id: campaign.id, campaign: {title: ""}
      end
      it "doesnt update with the record that is passed" do
        # comment out the validation
        expect(campaign.title).to eq(campaign.reload.title)
      end

      it "renders the edit template" do
        expect(response).to render_template(:edit)
      end

    end

  end

  describe "#destroy" do


    it "removes the campaign from the database" do
      # to give the Campaign a count, we have to call campaign
      campaign
      # instead of value, give it a block
      expect {delete :destroy, id: campaign.id}.to change{ Campaign.count}.by(-1)
      # count_before = Campaign.count
      # delete :destroy, id: campaign.id
      # count_after = Campaign.count
      # expect(count_after).to eq(count_before - 1)
      #
    end

    it "redirects to the index page" do
      delete :destroy, id: campaign.id
      expect(response).to redirect_to(campaigns_path)
    end

    it "sets a flash message" do
      delete :destroy, id: campaign.id
      expect(flash[:notice]).to be
    end

  end

end
