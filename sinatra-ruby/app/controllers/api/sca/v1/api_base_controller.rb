#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

require 'json'

class ApiBaseController < Sinatra::Base
  include ServiceHelper
  register Sinatra::Namespace

  set :raise_errors, false
  set :show_exceptions, false

  error BadRequest, ActionNotFound, ActionClosed, ConsentNotFound, ConnectionNotFound, JSON::Parser do
    name = env['sinatra.error'].class.name
    halt 400, { 'Content-Type' => 'application/json' }, { 'error_class' => name, 'error_message' => name }.to_json
  end
end
