# index.json.jbuilder
# json.array! here means we want to send the data back as an array
# json.campaigns will return a hash with key campaigns and value of titles
json.array! @campaigns do |campaign|
  json.title campaign.title.titleize
  json.api_url    api_v1_campaign_url(campaign)
  json.url        campaign_url(campaign)
  json.created_on formatted_date(campaign.created_at)
  json.end_date   formatted_date(campaign.end_date)
end
