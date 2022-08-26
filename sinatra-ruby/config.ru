#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

require 'rack'
require 'rack/contrib'
require './app'
require 'sidekiq/web'

use Rack::JSONBodyParser
use Rack::Reloader
use ProviderConnectionsController
use ProviderActionsController
use ProviderInstantActionController
use ProviderConsentsController
use SettingsController
use ConnectionsController
use ScaAuthController
use ActionsController
use ConsentsController

run Rack::URLMap.new('/' => IndexController, '/sidekiq' => Sidekiq::Web)
