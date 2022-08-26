class AddMultipleToActions < ActiveRecord::Migration[6.1]
  def change
    add_column :actions, :multiple, :boolean, default: false
  end
end
