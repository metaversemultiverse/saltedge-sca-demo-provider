#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

module ServiceHelper
  SCA_USER_ID = '123'.freeze

  # authenticator://saltedge.com/connect?configuration=https://saltedge.com/configuration&connect_query=A12345678
  def create_connect_app_link
    sca_connect_query_prefix = 'query-'
    sca_connect_query = "#{sca_connect_query_prefix}#{SCA_USER_ID}"

    app_link_prefix_connect = 'authenticator://saltedge.com/connect?configuration='

    @sca_service_url = SettingsHelper.sca_service_url
    @provider_id = SettingsHelper.provider_id

    configuration_url = "#{@sca_service_url}/api/authenticator/v2/configurations/#{@provider_id}"
    encoded_configuration_url = configuration_url.encode('UTF-8')
    encoded_connect_query = sca_connect_query.encode('UTF-8')

    "#{app_link_prefix_connect}#{encoded_configuration_url}&connect_query=#{encoded_connect_query}"
  end

  def create_action_qr_link(action_id)
    app_url = SettingsHelper.app_url
    provider_id = SettingsHelper.provider_id

    uri    = URI("#{app_url}/instant_action/qr")
    params = { action_id: action_id, provider_id: provider_id }
    uri.query = URI.encode_www_form(params)
    uri.to_s
  end

  # Verifies that request has ACCESS_TOKEN header and related Connection exist
  def verify_identity
    raise AuthorizationRequired unless access_token
    raise ConnectionNotFound unless connection
  end

  # Verifies payload data and creates new Connection in db
  def create_new_connection!
    request_data = params['data']

    raise StandardError::BadRequest unless request_data&.values_at(
      'enc_rsa_public_key',
      'return_url'
    )&.none?(&:blank?)

    decrypted_public_key = Jws.decrypt_public_rsa_key(request_data['enc_rsa_public_key'])

    Connection.create(
      id:         request_data['connection_id'],
      public_key: decrypted_public_key,
      return_url: request_data['return_url'],
      user_id:    SCA_USER_ID
    )
  end

  def revoke_connection(id)
    connection = Connection.find_by(id: id, revoked: false)
    raise StandardError::ConnectionNotFound unless connection

    connection.update!(revoked: true)
  end

  def create_authentication_page_url(connection_id, connect_query)
    app_url = SettingsHelper.app_url

    uri    = URI("#{app_url}/auth")
    params = { connection_id: connection_id }
    params[:connect_query] = connect_query if connect_query
    uri.query = URI.encode_www_form(params)
    uri.to_s
  end

  def authorize_connection(connection_id, user_id)
    connection = Connection.find_by(id: connection_id, revoked: false)

    if user_id != SCA_USER_ID && connection.nil?
      puts 'test'
    else
      access_token = SecureRandom.hex
      connection.update!(access_token: access_token, user_id: user_id)

      AuthenticationWorker.perform_async(
        sca_connection_id: connection.id,
        access_token: connection.access_token,
        public_key: connection.public_key
      )

      encrypted_token = encrypted_access_token(connection.access_token, connection.public_key)
      encoded_token = encrypted_token.encode('UTF-8')
      uri = URI(connection.return_url)
      uri.query = URI.encode_www_form({ access_token: encoded_token })
      uri.to_s
    end
  end

  def encrypted_access_token(token, rsa_public_key)
    public_key = Jws.rsa_key(rsa_public_key)
    json_token = { access_token: token }.to_json
    Base64.encode64(public_key.public_encrypt(json_token))
  end
end
