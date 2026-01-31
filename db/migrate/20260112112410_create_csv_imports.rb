class CreateCSVImports < ActiveRecord::Migration[8.1]
  def change
    create_table :csv_imports do |t|
      t.integer :status, null: false, default: 0
      t.json    :messages

      t.timestamps
    end
  end
end
