#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

class Consent < ActiveRecord::Base
  def set_consent_accounts(accounts)
    update!(accounts: accounts.to_json)
  end
end
