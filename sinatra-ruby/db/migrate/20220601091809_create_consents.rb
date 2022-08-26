class CreateConsents < ActiveRecord::Migration[6.1]
  def change
    create_table :consents do |t|
      t.string   :connection_id
      t.string   :user_id
      t.string   :consent_type
      t.string   :tpp_name
      t.string   :accounts, default: '[]'
      t.boolean  :balance, default: false
      t.boolean  :transactions, default: false
      t.datetime :expires_at
      t.boolean  :revoked, default: false
      t.timestamps
    end
  end
end
