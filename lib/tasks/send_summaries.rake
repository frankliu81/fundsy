namespace :send_summaries do
  desc "Sending daily summary of pledges on campaigns"
  # adding :environment means that the Rails environment has been loaded
  task :send_all => :environment do
    # send summary for each campaign
    Campaign.all.each do |campaign|
      SendCampaignSummaryJob.perform_later(campaign)
    end
  end
end
