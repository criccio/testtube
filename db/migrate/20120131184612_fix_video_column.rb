class FixVideoColumn < ActiveRecord::Migration
  def self.up
    remove_column :posts, :videourl
    change_table :posts do |t|
      t.has_attached_file :video
    end
  end

  def self.down
    add_column :posts, :videourl
    drop_attached_file :posts, :video
  end

end
