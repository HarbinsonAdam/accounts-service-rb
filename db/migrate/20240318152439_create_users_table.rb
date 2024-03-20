class CreateUsersTable < ActiveRecord::Migration[7.1]
  def up
    create_table :users, if_not_exists: true do |t|
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :dob, null: false
      t.string :password, null: false
      t.timestamps
    end

    # Add a unique index to the email column
    add_index :users, :email, unique: true, if_not_exists: true
  end

  def down
    # Ensure the index is removed before dropping the table
    remove_index :users, :email, if_exists: true
    drop_table :users, if_exists: true
  end
end
