class AddEventCategoryToEvents < ActiveRecord::Migration[6.1]
  def change
    add_reference :events, :event_category, null: true, foreign_key: true
  end
end
