require "faraday"
require "json"

BASE_URL = "http://localhost:3004"
API_KEY = "fb0fe7330b144f3d725026a4de77afca011123606480f15cf61ae62b07393b20"

conn = Faraday.new(url: BASE_URL) do |faraday|
  faraday.request :url_encoded  # form-encode POST params
  faraday.response :logger      # log requests to STDOUT
  faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
end

response = conn.get "/api/v1/campaigns", {api_key: API_KEY}

campaigns = JSON.parse(response.body)

# puts campaigns

campaigns.each do |campaign|
  puts campaign["title"]
end
