class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references  :user,        :null => false
      t.references  :comment,     :null => false
      t.boolean     :value,       :null => false, :default => true
      t.timestamps
    end

    add_index :votes, [:user_id, :comment_id], :uniq => true
    add_index :votes, :comment_id
    add_index :votes, :user_id

  end
end
