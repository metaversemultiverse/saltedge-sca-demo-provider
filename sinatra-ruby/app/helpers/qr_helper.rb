require 'rqrcode'

module QrHelper
  def create_qr_code(configuration_url)
    RQRCode::QRCode.new(configuration_url, level: :l).as_svg(
      offset:          0,
      color:           "000",
      shape_rendering: "crispEdges",
      module_size:     3,
      standalone:      true
    )
  end
end
