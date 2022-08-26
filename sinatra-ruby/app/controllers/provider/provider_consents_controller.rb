#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

class ProviderConsentsController < BaseController
  # http://localhost:8080/consents
  get '/consents' do
    @consents = Consent.all.order(id: :desc)
    erb :consents
  end

  # type: aisp, pisp_future, pisp_recurring
  get '/consents/create' do
    @active = Connection.where(user_id: params[:user_id]).present? ? true : false
    erb :create_consent
  end

  get '/consents/:consent_id/revoke' do
    consent = Consent.find_by(id: params[:consent_id])

    consent.update!(revoked: true)

    RevokeConsentWorker.perform_async(
      consent_id: consent.id.to_s
    )

    redirect '/consents'
  end

  post '/consents/create' do
    connections = Connection.where(user_id: params[:user_id]).select { |c| c.authorized? && !c.revoked }

    if connections.present?
      consent_account = [
        {
        'name': "Checking account #{params[:user_id]}",
        'iban': 'RO49AAAA1B31007593840000'
        }
      ].to_json

      consent = Consent.create!(
        user_id: connections.first.user_id,
        consent_type: params[:type_group] || 'aisp',
        tpp_name: 'Fentury',
        accounts: consent_account,
        balance: params[:balance] == 'on',
        transactions: params[:transactions] == 'on',
        expires_at: 90.days.from_now.utc
      )

      CreateConsentWorker.perform_async(
        consent_id: consent.id,
        connection_ids: connections.map(&:id)
      )
    end

    redirect '/connections'
  end
end
