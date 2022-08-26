#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

class ProviderConnectionsController < BaseController
  get '/connections' do
    @provider_connections = Connection.all.order(id: :desc)

    erb :connections
  end

  get '/connections/:connection_id/revoke' do
    connection_id = params['connection_id']
    connection = Connection.find_by(id: connection_id, revoked: false)

    connection.update!(revoked: true)

    RevokeConnectionWorker.perform_async(
      sca_connection_id: connection_id
    )

    redirect '/connections'
  end
end
