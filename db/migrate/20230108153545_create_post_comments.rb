class CreatePostComments < ActiveRecord::Migration[6.1]
  def change
    create_table :post_comments do |t|
      t.timestamps
      t.text :comment,       null:false
      t.integer :user_id,    null:false
      t.integer :post_id,    null:false
      t.boolean :is_deleted, null:false, default: false
    end
  end
end
