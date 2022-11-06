class AddParentToEvents < ActiveRecord::Migration[6.1]
  def change
    add_reference :events, :parent, null: true, foreign_key: { to_table: :events }
  end
end
