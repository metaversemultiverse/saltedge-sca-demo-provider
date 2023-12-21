require 'jwt'
require 'openssl'
require 'base64'

module Jws
  RS256 = 'RS256'.freeze

  # encode to Detached Jws https://tools.ietf.org/html/rfc7515#appendix-F
  def self.encode(payload)
    private_key_pem = SettingsHelper.app_private_key
    encoded_jws = JWT.encode(payload, rsa_key(private_key_pem), RS256, typ: 'JWT').to_s
    splitted_jws = encoded_jws.split('.')
    splitted_jws[1] = ''
    splitted_jws.join('.')
  end

  # verify Detached Jws https://tools.ietf.org/html/rfc7515#appendix-F
  def self.verify(raw_payload, signature, public_pem)
    splitted_jws = signature.split('.')
    splitted_jws[1] = Base64.urlsafe_encode64(raw_payload, padding: false)
    encoded_jws = splitted_jws.join('.')
    decoded = JWT.decode(encoded_jws, rsa_key(public_pem), true, algorithm: RS256)
    raise Error::JWTClaimMissing.new(attribute: :exp) if decoded.first['exp'].blank?

    true
  rescue OpenSSL::PKey::RSAError
    raise Error::InvalidPublicKey
  rescue JWT::ExpiredSignature
    raise Error::JWTExpiredSignature
  rescue JWT::VerificationError
    raise Error::JWTVerificationError
  rescue JWT::IncorrectAlgorithm
    raise Error::JWTIncorrectAlgorithm
  rescue JWT::DecodeError
    raise Error::JWTDecodeError
  end

  def self.rsa_key(pem)
    OpenSSL::PKey::RSA.new(pem)
  end

  def self.create_expires
    2.minutes.from_now.to_i
  end

  def self.encrypt_rsa(data, public_key_pem)
    puts "INCOMING PUBLIC KEY: #{public_key_pem}"

    public_key = OpenSSL::PKey::RSA.new(public_key_pem)
    public_key.public_encrypt(data)
  end

  def self.decrypt_public_rsa_key(encrypted_data)
    key  = encrypted_data['key'].gsub(/\n/, '')
    iv   = encrypted_data['iv'].gsub(/\n/, '')
    data = encrypted_data['data'].gsub(/\n/, '')

    private_key = OpenSSL::PKey::RSA.new(SettingsHelper.app_private_key)

    decoded_key  = Base64.decode64(key)
    decoded_iv   = Base64.decode64(iv)
    decoded_data = Base64.decode64(data)

    decrypted_key = private_key.private_decrypt(decoded_key)
    decrypted_iv  = private_key.private_decrypt(decoded_iv)

    aes256_decrypt(decrypted_key, decrypted_iv, decoded_data)
  end

  def self.aes256_decrypt(key, iv, data)
    decipher = OpenSSL::Cipher.new('AES-256-CBC')
    decipher.decrypt
    decipher.key = key
    decipher.iv = iv
    decipher.update(data) + decipher.final
  end

  def self.aes256_encrypt(key, iv, data)
    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.encrypt
    cipher.key = key
    cipher.iv = iv
    cipher.update(data) + cipher.final
  end

  def self.random_iv
    OpenSSL::Cipher.new('AES-256-CBC').random_iv
  end

  def self.random_key
    digest = Digest::SHA256.new
    digest.digest
  end
end
