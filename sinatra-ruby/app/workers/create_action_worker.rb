#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

class CreateActionWorker < BaseWorker
  sidekiq_options queue: 'sca-demo-sender', retry: false

  def perform(params)
    action = Action.find_by(id: params['action_id'])

    connections = Connection.all.select { |c| c.authorized? && !c.revoked? }

    authorization_code = SecureRandom.hex

    authorization = EncryptionTools.create_authorization_data(action, authorization_code)
    enc_authorizations = connections.map { |c| EncryptionTools.create_encrypted_action(authorization, c) }
    request_expires_at = Jws.create_expires

    action_authorizations = []

    connections.each do |c|
      hash = {
        'connection_id': c.id,
        'status': Action::PENDING,
        'authorization_code': authorization_code
      }

      action_authorizations << hash
    end

    action.update!(authorizations: action_authorizations.to_json)

    payload = {
      data: {
        action_id: action.code,
        user_id: '123',
        multiple: action.multiple,
        expires_at: action.expires_at.to_s,
        authorizations: enc_authorizations
      },
      exp: request_expires_at
    }

    url = "#{SettingsHelper.sca_service_url}/api/sca/v1/actions"

    do_callback_request(:post, url, payload)

    puts "sendActionCreateCallback: #{Time.now}, action_id: #{action.id}"
  end
end
