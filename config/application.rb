require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.active_job.queue_adapter = :delayed_job

    config.x.marina.docker_registry_host = ENV['DOCKER_REGISTRY_HOST']
    config.x.marina.docker_registry_port = ENV['DOCKER_REGISTRY_PORT']
    config.x.marina.docker_registry_user = ENV['DOCKER_REGISTRY_USER']
    config.x.marina.docker_registry_password = ENV['DOCKER_REGISTRY_PASSWORD']
    config.x.marina.docker_registry_jwt_key = ENV['DOCKER_REGISTRY_JWT_KEY']

    config.x.marina.docker_library_arch = ENV['DOCKER_LIBRARY_ARCH']

    config.x.marina.new_builder_key = ENV['NEW_BUILDER_KEY']

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              ENV['MAIL_HOST'],
      port:                 ENV['MAIL_PORT'],
      domain:               ENV['MAIL_DOMAIN'],
      user_name:            ENV['MAIL_USER'],
      password:             ENV['MAIL_PASSWORD'],
      authentication:       ENV['MAIL_AUTH_METHOD'],
      enable_starttls_auto: ENV['MAIL_STARTTLS'] == 'true'
      }


  end
end
