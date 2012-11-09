class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.belongs_to :tag
      t.belongs_to :comment

      t.timestamps
    end
    add_index :taggings, :tag_id
    add_index :taggings, :comment_id
    add_index :taggings, [:comment_id, :tag_id]
  end
end
