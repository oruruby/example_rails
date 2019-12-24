require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ExampleApp
  class Application < Rails::Application
    config.load_defaults 6.0
    config.api_only = true
    config.action_cable.disable_request_forgery_protection = true
    config.action_cable.url = Nenv.cable_url? ? Nenv.cable_url : 'ws://localhost/cable'
    config.action_cable.mount_path = Nenv.cable_url? ? nil : "/cable"
    config.any_cable_rack.run_rpc = true
  end
end
