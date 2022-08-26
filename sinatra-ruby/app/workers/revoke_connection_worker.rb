#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

class RevokeConnectionWorker < BaseWorker
  sidekiq_options queue: 'sca-demo-sender', retry: false

  def perform(params)
    sca_connection_id = params['sca_connection_id']
    request_expires_at = Jws.create_expires

    payload = {
      data: {},
      exp: request_expires_at
    }

    url = "#{SettingsHelper.sca_service_url}/api/sca/v1/connections/#{sca_connection_id}/revoke"

    do_callback_request(:put, url, payload)

    puts "revoke_callback: #{Time.now}, sca_connection_id: #{sca_connection_id}"
  end
end
