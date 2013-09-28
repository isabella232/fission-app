class FissionInit < ActiveRecord::Migration
  def change
    create_table :accounts do
      t.text :name, :null => false, :unique => true
      t.timestamps
    end

    create_table :users do
      t.text :username, :null => false, :unique => true
      t.text :password, :null => false
      t.text :name
      t.timestamps
    end
    add_index :users, :username

    create_table :account_users do
      t.integer :account_id, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
    add_index :account_users, [:account_id, :user_id], :unique => true

    create_table :api_tokens do
      t.integer :user_id, :null => false
      t.text :access_key, :null => false
      t.text :secret_key, :null => false
      t.timestamp :expires
      t.timestamps
    end
    add_index :api_tokens, [:access_key, :secret_key], :unique => true

    create_table :request_tokens do
      t.text :token, :null => false, :unique => true
      t.timestamp :expires
      t.timestamps
    end

    create_table :user_request_tokens do
      t.integer :user_id, :null => false
      t.text :request_token_id, :null => false
    end
    add_index :user_request_tokens, [:user_id, :request_token_id], :unique => true

    create_table :account_request_tokens do
      t.integer :account_id, :null => false
      t.text :request_token_id, :null => false
    end
    add_index :account_request_tokens, [:account_id, :request_token_id], :unique => true

    create_table :permissions do
      t.text :name, :null => false, :unique => true
      t.text :description, :null => false
      t.timestamps
    end

    create_table :account_permissions do
      t.integer :account_id, :null => false
      t.integer :permission_id, :null => false
      t.timestamps
    end
    add_index :account_permissions, [:account_id, :permission_id], :unique => true

    create_table :user_permissions do
      t.integer :user_id, :null => false
      t.integer :permission_id, :null => false
      t.timestamps
    end
    add_index :user_permissions, [:user_id, :permission_id], :unique => true

    create_table :user_emails do
      t.text :email, :null => false
      t.integer :user_id, :null => false
      t.timestamps
    end
    add_index :user_emails, [:user_id, :email], :unique => true

    create_table :account_emails do
      t.text :email, :null => false
      t.integer :account_id, :null => false
      t.timestamps
    end
    add_index :account_emails, [:account_id, :email], :unique => true

    create_table :jobs do
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
