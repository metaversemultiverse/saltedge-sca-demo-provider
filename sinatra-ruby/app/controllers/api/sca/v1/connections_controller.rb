#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

class ConnectionsController < ApiBaseController
  namespace '/api/sca/v1' do
    # CREATE NEW CONNECTION
    # Mobile client query this endpoint after scaning QR code and receiving configuration data
    # Create new Connection
    # Return new Connection Id and authentication page connect_url
    post '/connections' do
      new_connection = create_new_connection!

      {
        data: {
          authentication_url: create_authentication_page_url(new_connection.id, params['data']['connect_query']),
          connection_id:      new_connection.id
        }
      }.to_json
    end

    put '/connections/:connection_id/revoke' do
      connection_id = params['connection_id']

      revoke_connection(connection_id)

      { 
        data: {
          connection_id: connection_id
        }
      }.to_json
    end
  end
end
