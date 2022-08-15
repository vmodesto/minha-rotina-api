class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.string :status
      t.references :user, null: false, foreign_key: true
      t.string :priority

      t.timestamps
    end
  end
end
