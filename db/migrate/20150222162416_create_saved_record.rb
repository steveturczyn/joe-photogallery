class CreateSavedRecord < ActiveRecord::Migration
  def change
    create_table :saved_records do |t|
      t.integer :picture_id
      t.string :record_json
      t.references :user
    end
  end
end
