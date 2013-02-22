class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.string :login
      t.references :post

      t.timestamps
    end
    add_index :votes, :post_id
  end
end
