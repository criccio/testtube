class AddSendemailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :send_email, :boolean, :null => true, :default => true
  end
end
