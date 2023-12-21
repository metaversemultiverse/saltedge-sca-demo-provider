class UpdateActionWorker < BaseWorker
  sidekiq_options queue: 'sca-demo-sender', retry: false

  def perform(params)
    action_to_update = Action.find_by(id: params['action_id'])

    connections = Connection.all.select { |c| c.authorized? && !c.revoked? }

    authorization_code = SecureRandom.hex

    authorization = EncryptionTools.create_authorization_data(action_to_update, authorization_code)
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

    parsed_authorizations = JSON.parse(action_to_update.authorizations)

    action_to_update.update!(authorizations: (parsed_authorizations + action_authorizations).to_json)

    payload = {
      data: {
        action_id: action_to_update.code,
        user_id: '123',
        multiple: true,
        expires_at: action_to_update.expires_at.to_s,
        authorizations: enc_authorizations
      },
      exp: request_expires_at
    }

    url = "#{SettingsHelper.sca_service_url}/api/sca/v1/actions/#{action_to_update.code}"

    do_callback_request(:put, url, payload)

    puts "sendActionUpdateCallback: #{Time.now}, action_id: #{action_to_update.id}"
  end
end
