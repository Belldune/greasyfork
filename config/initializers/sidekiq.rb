if Rails.env.production?
  Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://192.168.166.212:6379/0' }
  end
end

if Rails.env.production?
  Sidekiq.configure_server do |config|
    config.on(:startup) do
      [BackgroundJob, ScriptDeleteJob, ConsecutiveBadRatingsJob, UserFloodJob, DiscussionReadCleanupJob, BannedUserDeleteJob, ScriptPageViewUpdateJob]
        .reject(&:enqueued?)
        .each(&:perform_later)
    end
  end
end
