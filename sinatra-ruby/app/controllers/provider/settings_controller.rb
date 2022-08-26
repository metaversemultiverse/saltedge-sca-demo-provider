#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

class SettingsController < BaseController
  get '/settings' do
    @app_url = SettingsHelper.app_url
    @sca_service_url = SettingsHelper.sca_service_url
    @provider_id = SettingsHelper.provider_id
    @public_key = SettingsHelper.sca_public_key

    erb :settings
  end
end
