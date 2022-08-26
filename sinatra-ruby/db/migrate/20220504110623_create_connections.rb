class CreateConnections < ActiveRecord::Migration[6.1]
  def change
    create_table :connections do |t|
      t.string   :user_id
      t.string   :public_key, limit: 4096
      t.string   :push_token, limit: 4096
      t.string   :platform, limit: 32
      t.string   :return_url, limit: 4096
      t.string   :connect_session_token, limit: 4096
      t.string   :access_token, limit: 4096
      t.boolean  :revoked, default: false
      t.timestamps
    end
  end
end
