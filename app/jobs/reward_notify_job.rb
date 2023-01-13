class RewardNotifyJob < ApplicationJob
  def perform(reward, receiver)
    if url = ENV['WEBHOOK_NOTIFICATION_URL']
      HTTP.post(url, json: {id: reward.uuid, user_id: receiver.external_id})
    end
  end
end