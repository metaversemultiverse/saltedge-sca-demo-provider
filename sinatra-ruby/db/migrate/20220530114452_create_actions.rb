class CreateActions < ActiveRecord::Migration[6.1]
  def change
    create_table :actions do |t|
      t.string :status
      t.string :code
      t.string :description_type
      t.timestamps
    end
  end
end
