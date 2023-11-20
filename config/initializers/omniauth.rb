Rails.application.config.middleware.use OmniAuth::Builder do
  provider :marvin, ENV["FORTYTWO_KEY"], ENV["FORTYTWO_SECRET"]
end
