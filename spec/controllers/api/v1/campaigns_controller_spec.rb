require 'rails_helper'

RSpec.describe Api::V1::CampaignsController, type: :controller do
  # No need to generate API key here anymore because it will be generated when the user is created
  let(:user) { FactoryGirl.create(:user)}
  # We need to render_views first.  By default, Controller Specs don't render views
  # (for speed and separation purposes)
  # In here we need to have the controller spec render views because for the
  # index action we are using jBuilder which is a view to render JSON
  render_views
  # generate a campaign
  let(:campaign) { FactoryGirl.create(:campaign)}

  # generate a campaign
  describe '#index' do
    context 'with no API key' do
      it 'responds with a 403 HTTP status code' do
        get :index
        # test for forbidden error
        expect(response.status).to eq(403)
      end
    end

    context 'with API key' do
      it 'renders the campaigns title in the JSON response' do
        campaign
        get :index, api_key: user.api_key, format: :json
        expect(response.body).to have_text /#{campaign.title.titleize}/i
        puts '>>>>>>>>>'
        puts response.body
        puts response.status
        puts '>>>>>>>>>'
      end
    end
  end

  describe '#show' do
    context 'with api_key_provided' do
      it 'renders a JSON with a campaign title' do
        get :show, id: campaign.id, format: :json, api_key: user.api_key
        response_body = JSON.parse(response.body)
        expect(response_body['campaign']['title']).to eq(campaign.title.titleize)
      end
    end
  end

end
