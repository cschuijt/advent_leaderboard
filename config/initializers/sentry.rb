if ENV["SENTRY_DSN"]
  Sentry.init do |config|
    config.dsn = ENV.fetch("SENTRY_DSN")
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    config.traces_sample_rate = 1.0

    # Profile all requests, for funsies
    config.profiles_sample_rate = 1.0

    # Release is the commit SHA we are on.
    config.release = `git rev-parse HEAD`.chomp
  end
end
