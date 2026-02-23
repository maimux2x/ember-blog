class AddPublishedAtToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :published_at, :datetime

    execute "UPDATE posts SET published_at = created_at"

    change_column_null :posts, :published_at, false
  end
end
