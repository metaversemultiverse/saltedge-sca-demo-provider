class CloseActionWorker < BaseWorker
  sidekiq_options queue: 'sca-demo-sender', retry: false

  def perform(params)
    action = Action.find_by(id: params['action_id'])
    request_expires_at = Jws.create_expires

    payload = {
      data: {
        action_id: action.code
      },
      exp: request_expires_at
    }

    url = "#{SettingsHelper.sca_service_url}/api/sca/v1/actions/#{action.code}/close"

    do_callback_request(:put, url, payload)

    puts "sendActionCloseCallback: #{Time.now}, action_id: #{action.id}"
  end
end
