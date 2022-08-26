class AddAuthorizationsFieldToAction < ActiveRecord::Migration[6.1]
  def change
    add_column :actions, :authorizations, :jsonb, default: []
  end
end
