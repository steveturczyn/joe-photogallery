Photogallery::Application.configure do
  config.cache_classes = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :letter_opener

  # Set up Devise configuration
  config.action_mailer.default_url_options = {host: "localhost:3000"}

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Raise an error on page load if there are pending migrations
  # config.active_record.migration_error = :page_load
end
