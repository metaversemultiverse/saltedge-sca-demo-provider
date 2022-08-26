#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

class ScaAuthController < ApiBaseController
  get '/auth' do
    url    = request.url
    uri    = URI.parse(url)
    query_params = CGI.parse(uri.query)

    @sca_connection_id = query_params['connection_id'].first
    connect_query      = query_params['connect_query'].first
    @error = 'Invalid environment. Authenticator is required.' unless @sca_connection_id

    if connect_query.blank?
      redirect 'auth'
    else
      redirect "#{authorize_connection(@sca_connection_id, '123')}"
    end
  end
end
