class AuthenticationWorker < BaseWorker
  sidekiq_options queue: 'sca-demo-sender', retry: false

  def perform(params)
    sca_connection_id  = params['sca_connection_id']
    access_token       = params['access_token']
    public_key         = params['public_key']
    request_expires_at = Jws.create_expires

    payload = {
      data: {
        user_id: '123',
        access_token: access_token,
        rsa_public_key: public_key
      },
      exp: request_expires_at
    }
    url = "#{SettingsHelper.sca_service_url}/api/sca/v1/connections/#{sca_connection_id}/success_authentication"

    do_callback_request(:put, url, payload)

    puts "send_success_authentication_callback: #{Time.now}, sca_connection_id: #{sca_connection_id}"
  end
end
