#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

class RevokeConsentWorker < BaseWorker
  sidekiq_options queue: 'sca-demo-sender', retry: false

  def perform(params)
    consent_id = params['consent_id']
    request_expires_at = Jws.create_expires

    payload = {
      data: {},
      exp: request_expires_at
    }

    url = "#{SettingsHelper.sca_service_url}/api/sca/v1/consents/#{consent_id}/revoke"

    do_callback_request(:put, url, payload)

    puts "revoke_consent_callback: #{Time.now}, consent_id: #{consent_id}"
  end
end
