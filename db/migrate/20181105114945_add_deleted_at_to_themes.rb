class AddDeletedAtToThemes < ActiveRecord::Migration[5.2]
  def change
    add_column :themes, :deleted_at, :datetime
    add_index :themes, :deleted_at
  end
end
