#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

require 'sinatra/cookies'

module CookieHelper
  def save_action_cookie(key, data, response)
    response.set_cookie(
      key,
      :value   => data,
      :domain  => request.host == 'localhost' ? "" : request.host,
      :expires => 5.minutes.from_now.utc
    )
  end

  def clear_action_cookie(key, response)
    response.set_cookie(
      key,
      :value   => '',
      :domain  => request.host == 'localhost' ? "" : request.host,
      :expires => Time.now
    )
  end

  def get_action_cookie(key)
    request.cookies[key]
  end
end
