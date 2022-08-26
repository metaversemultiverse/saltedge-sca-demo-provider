#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

require 'sinatra'
require 'sidekiq'
require 'redis'
require 'sidekiq/api'
require 'rest-client'

class BaseWorker
  include Sidekiq::Worker

  def do_callback_request(method, url, payload)
    headers = {
      content_type:       :json,
      accept:             :json,
      'Provider-Id':      SettingsHelper.provider_id,
      'x-jws-signature':  Jws.encode(payload)
    }
    @response = RestClient::Request.execute(
      method:  method,
      url:     url,
      headers: headers,
      payload: payload.to_json
    )
    http_code = http_code_from(@response, default: 200)
    JSON.parse(response)
  rescue => e
    puts "do_callback_request exception: #{url}, error: #{e.message}"
  end

  def self.http_code_from(error, default: 500)
    %i(http_code code).map { |attr| error.try(attr) || error.try(:response).try(attr) }.detect(&:present?) || default
  end
end
