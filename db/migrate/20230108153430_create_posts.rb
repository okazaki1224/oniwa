class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.timestamps
      t.integer :user_id,      null: false
      t.integer :genre_id,     null: false
      t.string :title,         null: false
      t.string :body,          null: false
      t.integer :post_status,  null: false, default:0
    end
  end
end
