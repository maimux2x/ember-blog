class CreateTaggings < ActiveRecord::Migration[8.0]
  def change
    create_table :taggings do |t|
      t.references :post, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.integer :position, null: false
      t.index [ :post_id, :position ], unique: true

      t.timestamps
    end
  end
end
