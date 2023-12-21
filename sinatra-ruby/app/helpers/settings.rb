require 'sinatra/base'

module SettingsHelper
  def self.file_path(file)
    File.join('config', file)
  end

  def self.sca_public_key
    File.read(file_path('sca_public_rsa_production.pem'))
  end

  def self.app_public_key
    # NOTE: Generate RSA key
    File.read(file_path('app_public_rsa_development.pem'))
  end

  def self.app_private_key
    # NOTE: Generate RSA key
    File.read(file_path('app_private_rsa_development.pem'))
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
