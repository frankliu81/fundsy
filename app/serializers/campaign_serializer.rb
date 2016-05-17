class CampaignSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :url, :created_at
  has_many :pledges

  # We can pass methods in this file to grab other attributes
  # that may not be in our model (e.g. url). We can test this by
  # checking a campaign, e.g. localhost:3000/api/v1/campaigns/1.
  # The downside of this is that we don't have access to all the
  # helper_methods in our model - we will need to include ApplicationHelper.
  include ApplicationHelper

  def title
    # this will titleize the title attribute in the returned JSON object
    object.title.titleize
  end

  def url
    campaign_url(object, host: 'http://localhost:3004')
  end

  def created_at
    formatted_date(object.created_at)
  end

end
