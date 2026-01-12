class CreateCSVImports < ActiveRecord::Migration[8.1]
  def change
    create_table :csv_imports do |t|
      t.timestamps
    end
  end
end
