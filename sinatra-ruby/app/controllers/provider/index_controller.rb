class IndexController < BaseController
  get '/' do
    @qr = create_qr_code(create_connect_app_link)

    erb :index
  end
end
