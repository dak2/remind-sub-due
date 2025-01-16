class DropPassWordDigestColumn < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :password_digest
    add_column :users, :uid, :string, null: false
  end
end
