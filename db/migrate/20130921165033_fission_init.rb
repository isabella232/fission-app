class FissionInit < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.text :name, :null => false, :unique => true
      t.text :alias
      t.timestamps
    end

    create_table :users do |t|
      t.text :username, :null => false, :unique => true
      t.text :alias
      t.text :name
      t.integer :base_account_id, :unique => true
      t.timestamps
    end
    add_index :users, :username

    create_table :identities do |t|
      t.text :unique_id, :null => false
      t.text :provider, :null => false
      t.text :name
      t.text :email
      t.text :nickname
      t.text :first_name
      t.text :last_name
      t.text :location
      t.text :description
      t.text :image
      t.text :phone
      t.text :password
      t.text :password_digest
      t.integer :user_id, :null => false
      t.timestamps
    end
    add_index :identities, :user_id
    add_index :identities, [:user_id, :provider, :unique_id], :unique => true

    create_table :account_users do |t|
      t.integer :account_id, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
    add_index :account_users, [:account_id, :user_id], :unique => true
    add_index :account_users, :user_id

    create_table :api_consumers do |t|
      t.text :key, :null => false, :unique => true
      t.text :secret, :null => false
      t.boolean :enabled, :null => false, :default => true
      t.datetime :expires
      t.integer :account_id, :null => false
      t.timestamps
    end
    add_index :api_consumers, [:account_id, :key], :unique => true

    create_table :api_tokens do |t|
      t.text :key, :null => false
      t.text :secret, :null => false
      t.datetime :expires
      t.boolean :enabled, :null => false, :default => true
      t.integer :api_consumer_id, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
    add_index :api_tokens, [:api_consumer_id, :key], :unique => true
    add_index :api_tokens, :user_id

    create_table :permissions do |t|
      t.text :name, :null => false, :unique => true
      t.text :description, :null => false
      t.timestamps
    end

    create_table :account_permissions do |t|
      t.integer :account_id, :null => false
      t.integer :permission_id, :null => false
      t.timestamps
    end
    add_index :account_permissions, [:account_id, :permission_id], :unique => true

    create_table :user_permissions do |t|
      t.integer :user_id, :null => false
      t.integer :permission_id, :null => false
      t.timestamps
    end
    add_index :user_permissions, [:user_id, :permission_id], :unique => true

    create_table :user_emails do |t|
      t.text :email, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
    add_index :user_emails, [:user_id, :email], :unique => true

    create_table :account_emails do |t|
      t.text :email, :null => false
      t.integer :account_id, :null => false
      t.timestamps
    end
    add_index :account_emails, [:account_id, :email], :unique => true

    create_table :jobs do |t|
      t.text :token, :null => false
      t.integer :user_id
      t.integer :account_id
      t.text :uuid, :null => false
      t.text :location, :null => false
      t.text :state, :null => false
      t.text :reason
      t.timestamps
    end
    add_index :jobs, :uuid
  end
end
