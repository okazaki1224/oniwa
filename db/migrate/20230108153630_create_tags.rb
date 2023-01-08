class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.timestamps
      t.string :tag_name

    end
    add_index :tags, :tag_name, unique: true
  end
end
