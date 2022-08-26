#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

class IndexController < BaseController
  get '/' do
    @qr = create_qr_code(create_connect_app_link)

    erb :index
  end
end
