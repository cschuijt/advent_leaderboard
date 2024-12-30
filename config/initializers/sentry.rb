if ENV["SENTRY_DSN"] && !ENV["SENTRY_DSN"].blank?
  Sentry.init do |config|
    config.dsn = ENV.fetch("SENTRY_DSN")
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    config.traces_sample_rate = ENV.fetch("SENTRY_TRACE_SAMPLE_RATE") { 1.0 }&.to_f

    # Profile all requests, for funsies
    config.profiles_sample_rate = ENV.fetch("SENTRY_PROFILE_SAMPLE_RATE") { 0.05 }&.to_f
  end
end
