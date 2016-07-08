class CreateReferrerInitStructure < ActiveRecord::Migration
  def change
    create_table :referrer_users do |t|
      t.string :token
      t.integer :main_app_user_id
      t.string  :main_app_user_type

      t.timestamps null: false
    end
    add_index :referrer_users, [:main_app_user_type, :main_app_user_id], name: 'referrer_users_main_app_user'

    create_table :referrer_sessions do |t|
      t.integer :user_id
      t.datetime :active_until

      t.timestamps null: false
    end
    add_index :referrer_sessions, :user_id

    create_table :referrer_sources do |t|
      t.integer :session_id
      t.string :referrer
      t.string :entry_point
      t.string :utm_source
      t.string :utm_campaign
      t.string :utm_medium
      t.string :utm_content
      t.string :utm_term
      t.string :kind
      t.boolean :priority, default: false

      t.timestamps null: false
    end
    add_index :referrer_sources, :session_id
  end
end
