#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

require_relative '../spec_helper'
require 'jwt'
require 'openssl'
require 'base64'

describe Jws do
  describe 'decrypt_public_rsa_key' do
    it 'decrypts rsa key with private key' do
      encrypted_entity = {
        'key' => 'LY7JSbVzR0/WtUqkHZF4wn3cU3Bq8zsiUzyBmdg55DNUghM6/xgr1IZ3cDgSN08a1KBTYOclGASjOQESidbFtwJACV+kmQUuONJP6yfQs0WLz2rqLh523zSgafvGTKva63cDH4mp24gtyXzfEn1mnkjOKutAjXMnbmlPl2jcBg3VZ9RVmdtMRd4vsIHBQrYxt57ulXDpEbA8fThBg/7HeQbm5kflWTqP2kRIb26iIHyFydJKBhWtMimhze2FKMtF8Jjn4euHt0Q3YI+C3USeKsVGKG2sNEb36+KPX6oHkrPoT9Q284d1XZERIWb7grta2KUrGcFhIJ0sEwNlknefzQ==',
        'iv' => 'ZoVEcn+kw0XpupasD7ME2K1ElK+UiJ53rMveAaXy7pCWS6UrXzHYpkqFSe0Eql5ABN4tar5b280pymkxeLn3H6PCzR66yhd8spGq2OFuLpua+Ib1VHyrQxjPYFyAWAf3mcvvm8hU6Zs0MDDkLNiFd9oyMOPPb4JPUFDTMfl3px+djcAlf1M3tuaRkERusFoewqhp3QPm5CKTlFq8dTC+/jO3sPQqPrXKLmXM8yqA+0ouZ/8dVBjf0iEjW2xdbFhonMe370PgffdTRQ+92oayJYhUHQtS7znMbzNft3zzNk6y/hvpvioPMM4HnHLTBgq3DW0MF82REFwZIm3dV9L4KQ==',
        'data' => 'jqQ7By0M6TWYQGGtLWbHFTaANKF4sSfUpOtxV6vBo0B2gceKO2QdF1Olq2azEy3nCzG62qCdwqEi/88iSEZMmsoiukOY8R2qAmpxWRjgQmot11kMFbBfjEOTLtASU01g1FNIKvLflanZ51l4HnpYAjH6LndhlXy4wWygRZPAguzETEwjBZFiC4J/JgQfS75cz093iVkoKgb3I4q7WzvhkhIkfizlyIsLDRNHgCHrae1PkWjTucVLdh8NUNsJUXdVkwDPBzOwYonZT2O2wj4zcRXb9plLdkYXYIzYu6sNdhw4NZZ+fYgCTzjppbueH1p4x2jdXXZEj4aB48L4ngB7KR4CBp9qzHZRcS6Ylkefr+GFw/m1WTGSYKAIftyIPfnf3rgQYNYG8SvvHW18xg+IfH54dCfZ9mLnTNszHHRUt9eMHT1MiFOkTJ35/a7RdNHCBJ2askx2soYcQj2hWxVuDZ/9NlMO4ntDw0AF6RYEi93YLAcFEd85u4Nbp6sv/mmwR3/DqUSwu9Tdu/dJpPuJIKEN3Rf2fdq1w08S9w7mZ/rqsqRQ04/aqoNBP88ePlIusN7XU+izwmRaaW1uCRubwyWVFU2r3Vv0YsD8AfU9mlg='
      }

      expect(Jws.decrypt_public_rsa_key(encrypted_entity)).to include('-----BEGIN PUBLIC KEY-----')
    end
  end
end
