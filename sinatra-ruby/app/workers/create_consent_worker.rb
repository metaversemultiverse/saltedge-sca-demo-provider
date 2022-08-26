#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

class CreateConsentWorker < BaseWorker
  sidekiq_options queue: 'sca-demo-sender', retry: false

  def perform(params)
    consent = Consent.find_by(id: params['consent_id'])

    return unless consent

    consent_data = EncryptionTools.create_consent_data(consent)

    connection_ids = params['connection_ids']
    connections = connection_ids.map { |id| Connection.find_by(id: id) }

    enc_consents = connections.map { |c| EncryptionTools.create_encrypted_consent(consent_data, c) }
    request_expires_at = Jws.create_expires

    payload = {
      data: {
        consent_id: consent.id.to_s,
        user_id: consent.user_id.to_s,
        consents: enc_consents
      },
      exp: request_expires_at
    }

    url = "#{SettingsHelper.sca_service_url}/api/sca/v1/consents"

    do_callback_request(:post, url, payload)

    puts "sendConsentCreateCallback: #{Time.now}, scaConsentId: #{consent.id}"
  end
end
