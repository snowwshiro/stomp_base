class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.string :author, null: false
      t.datetime :published_at
      t.string :status, default: 'draft', null: false

      t.timestamps
    end
    
    add_index :posts, :status
    add_index :posts, :published_at
    add_index :posts, [:status, :published_at]
  end
end
