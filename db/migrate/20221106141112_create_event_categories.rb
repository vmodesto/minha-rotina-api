class CreateEventCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :event_categories do |t|
      t.string :name, unique: true

      t.timestamps
    end
  end
end
