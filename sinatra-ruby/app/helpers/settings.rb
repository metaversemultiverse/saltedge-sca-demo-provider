#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

require 'sinatra/base'

module SettingsHelper
  def self.file_path(file)
    File.join('config', file)
  end

  def self.sca_public_key
    File.read(file_path(APP_SETTINGS.sca_public_key))
  end

  def self.app_private_key
    File.read(file_path(APP_SETTINGS.app_private_key))
  end

  def self.app_url
    APP_SETTINGS.service_url
  end

  def self.sca_service_url
    APP_SETTINGS.sca_service_url
  end

  def self.provider_id
    APP_SETTINGS.provider_id
  end
end
