#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

class Connection < ActiveRecord::Base
  def unauthorized?
    access_token.blank? || public_key.blank?
  end

  def authorized?
    !unauthorized?
  end
end
