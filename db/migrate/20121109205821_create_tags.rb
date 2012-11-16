class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.string :param_name

      t.timestamps
    end
    add_index :tags, :name
    add_index :tags, :param_name
  end
end
