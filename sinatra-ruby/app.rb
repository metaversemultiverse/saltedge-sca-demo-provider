#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

require 'sinatra'
require 'sinatra/namespace'
require 'sinatra/config_file'
require 'sinatra/activerecord'
require 'sinatra/reloader' if development?
require 'pry'
require 'yaml'
require 'sidekiq'
require 'sidekiq/web'
require 'redis'

# Models
require_relative 'app/models/connection'
require_relative 'app/models/action'
require_relative 'app/models/consent'

# Helpers
require_relative 'app/helpers/errors'
require_relative 'app/helpers/settings'
require_relative 'app/helpers/qr_helper'
require_relative 'app/helpers/service_helper'
require_relative 'app/helpers/jws'
require_relative 'app/helpers/encryption_tools'
require_relative 'app/helpers/cookie_helper'

# Workers
require_relative 'app/workers/base_worker'
require_relative 'app/workers/authentication_worker'
require_relative 'app/workers/revoke_consent_worker'
require_relative 'app/workers/revoke_connection_worker'
require_relative 'app/workers/create_action_worker'
require_relative 'app/workers/update_action_worker'
require_relative 'app/workers/close_action_worker'
require_relative 'app/workers/create_consent_worker'
require_relative 'app/workers/confirm_authorizations_worker'

# Controllers
require_relative 'app/controllers/provider/base_controller'
require_relative 'app/controllers/provider/index_controller'
require_relative 'app/controllers/provider/provider_connections_controller'
require_relative 'app/controllers/provider/provider_actions_controller'
require_relative 'app/controllers/provider/provider_instant_action_controller'
require_relative 'app/controllers/provider/provider_consents_controller'
require_relative 'app/controllers/provider/settings_controller'

# API
require_relative 'app/controllers/api/sca/v1/api_base_controller'
require_relative 'app/controllers/api/sca/v1/connections_controller'
require_relative 'app/controllers/api/sca/v1/sca_auth_controller'
require_relative 'app/controllers/api/sca/v1/actions_controller'
require_relative 'app/controllers/api/sca/v1/consents_controller'

enable :sessions
set :bind, '0.0.0.0'
set :port, 4567
set :database_file, 'config/database.yml'

helpers SettingsHelper
helpers QrHelper
helpers ServiceHelper
helpers Jws
helpers EncryptionTools
helpers CookieHelper

APP_SETTINGS = OpenStruct.new(YAML.load_file('config/application.yml')[settings.environment.to_s])

options = {
  url: "redis://#{APP_SETTINGS.sidekiq['host']}:#{APP_SETTINGS.sidekiq['port']}/#{APP_SETTINGS.sidekiq['database']}"
}

Sidekiq.configure_client { |config| config.redis = options }
Sidekiq.configure_server { |config| config.redis = options }

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  [username, password] == [APP_SETTINGS.sidekiq['username'], APP_SETTINGS.sidekiq['password']]
end
