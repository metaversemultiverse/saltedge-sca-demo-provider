#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

class ConsentsController < ApiBaseController
  namespace '/api/sca/v1/consents' do
    put '/:consent_id/revoke' do
      consent = Consent.find_by(id: params['consent_id'])

      raise ConsentNotFound unless consent

      consent.update!(revoked: true)

      { data: {} }.to_json
    end
  end
end
