#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

require 'json'

module EncryptionTools
  # return authorization_data as json string
  def self.create_authorization_data(action, code)
    description = case action.description_type
                  when 'html'
                    create_html_description
                  when 'json'
                    create_json_description(action)
                  else
                    create_text_description
                  end
    description[:extra] = create_extra

    authorization_data = {
      title: 'Access account information',
      description: description,
      authorization_code: code, # unique code per each authorization
      created_at: Time.now.iso8601,
      expires_at: action.expires_at.iso8601
    }
    authorization_data.to_json
  end

  # AES-256-CBC
  def self.create_encrypted_action(data, connection)
    public_key = connection.public_key

    key = Jws.random_key
    iv = Jws.random_iv

    {
      connection_id: connection.id,
      key: Base64.encode64(Jws.encrypt_rsa(key, public_key)),
      iv: Base64.encode64(Jws.encrypt_rsa(iv, public_key)),
      data: Base64.encode64(Jws.aes256_encrypt(key, iv, data))
    }
  end

  def self.decrypt_action(data)
    key  = data['key'].gsub(/\n/, '')
    iv   = data['iv'].gsub(/\n/, '')
    data = data['data'].gsub(/\n/, '')

    private_key = OpenSSL::PKey::RSA.new(SettingsHelper.app_private_key)

    decoded_key  = Base64.decode64(key)
    decoded_iv   = Base64.decode64(iv)
    decoded_data = Base64.decode64(data)

    decrypted_key = private_key.private_decrypt(decoded_key)
    decrypted_iv  = private_key.private_decrypt(decoded_iv)

    aes256_decrypt(decrypted_key, decrypted_iv, decoded_data)
  end

  # AES-256-CBC
  def self.create_encrypted_consent(data, connection)
    public_key = connection.public_key

    key = Jws.random_key
    iv = Jws.random_iv

    {
      connection_id: connection.id,
      expires_at: data[:expires_at],
      key: Base64.encode64(Jws.encrypt_rsa(key, public_key)),
      iv: Base64.encode64(Jws.encrypt_rsa(iv, public_key)),
      data: Base64.encode64(Jws.aes256_encrypt(key, iv, data.to_json))
    }
  end

  def self.create_consent_data(consent)
    {
      id: consent.id.to_s,
      consent_type: consent.consent_type,
      tpp_name: consent.tpp_name,
      accounts: JSON.parse(consent.accounts),
      shared_data: {
        balance: consent.balance,
        transactions: consent.transactions
      },
      created_at: consent.created_at.iso8601,
      expires_at: consent.expires_at.iso8601
    }
  end

  private

  def self.create_html_description
    { html: '<body><p><b>TPP</b> is requesting your authorization to access account information data from <b>Demo Bank</b></p></body>' }
  end

  def self.create_json_description(action)
    {
      payment: {
        payee: 'TPP',
        amount: '100.0',
        account: 'MD24 AG00 0225 1000 1310 4168',
        payment_date: action.created_at_description,
        reference: 'X1',
        fee: 'No fee',
        exchange_rate: '1.0'
      }
    }
  end

  def self.create_text_description
    { text: 'TPP is requesting your authorization to access account information data from Demo Bank' }
  end

  def self.create_extra
    {
      action_date: 'Today',
      device: 'Google Chrome',
      location: 'Munich, Germany',
      ip: '127.0.0.0'
    }
  end
end
