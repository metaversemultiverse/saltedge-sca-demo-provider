#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

class ActionsController < ApiBaseController
  namespace '/api/sca/v1/actions' do
    post '/:action_id' do
      action = Action.find_by(id: params['action_id'])

      raise ActionNotFound unless action

      connection_id = params['data']['connection_id']

      raise BadRequest::WrongRequestFormat unless connection_id

      connection = Connection.find_by(id: connection_id)

      raise ConnectionNotFound unless connection

      create_action_payload(action, connection)
    end

    put '/:action_id/confirm' do
      action = Action.find_by(code: params['action_id'])

      raise ActionNotFound unless action
      raise ActionClosed if action.closed?

      ConfirmAuthorizationsWorker.perform_async(
        action_id: action.id,
        authorization_code: decrypted_request['authorization_code'],
        is_confirm: true
      )

      {
        data: {
          close_action: true
        }
      }.to_json
    end

    put '/:action_id/deny' do
      action = Action.find_by(code: params['action_id'])

      raise ActionNotFound unless action
      raise ActionClosed if action.closed?

      ConfirmAuthorizationsWorker.perform_async(
        action_id: action.id,
        authorization_code: decrypted_request['authorization_code'],
        is_confirm: false
      )

      {
        data: {
          close_action: true
        }
      }.to_json
    end

    private

    def create_action_payload(action, connection)
      authorization           = EncryptionTools.create_authorization_data(action)
      encrypted_authorization = EncryptionTools.create_encrypted_action(authorization, connection)

      {
        data: {
          action_id: action.id.to_s,
          user_id: SCA_USER_ID,
          multiple: action.multiple,
          expires_at: action.expires_at.to_s,
          authorization: encrypted_authorization
        }
      }.to_json
    end

    def parsed_original_request
      JSON.parse(params['data']['original_request'])['data']
    end

    def decrypted_request
      JSON.parse(Jws.decrypt_public_rsa_key(parsed_original_request))
    end
  end
end
