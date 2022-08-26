#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

class BaseController < Sinatra::Base
  include ServiceHelper
  include SettingsHelper
  include CookieHelper
  include QrHelper

  set :show_exceptions, false

  register Sinatra::Namespace

  configure do
    set :views, 'app/resources/views'
  end
end
