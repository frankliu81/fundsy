class SendCampaignSummaryJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    campaign = args[0]
    puts ">>>> SENDING CAMPAIGN SUMMARY for #{campaign.title}"
  end
end
