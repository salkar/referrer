class CreateReferrerInitStructure < ActiveRecord::Migration
  def change
    create_table :referrer_users do |t|
      t.string :token

      t.timestamps null: false
    end

    create_table :referrer_users_main_app_users do |t|
      t.integer :user_id
      t.integer :main_app_user_id
      t.string  :main_app_user_type

      t.timestamps null: false
    end
    add_index :referrer_users_main_app_users, [:main_app_user_type, :main_app_user_id], name: 'referrer_users_main_app_users_mau'
    add_index :referrer_users_main_app_users, :user_id

    create_table :referrer_sessions do |t|
      t.integer :user_id
      t.datetime :active_from
      t.datetime :active_until

      t.timestamps null: false
    end
    add_index :referrer_sessions, :user_id

    create_table :referrer_sources do |t|
      t.integer :session_id
      t.string :referrer
      t.string :entry_point
      t.integer :client_duplicate_id
      t.string :utm_source
      t.string :utm_campaign
      t.string :utm_medium
      t.string :utm_content
      t.string :utm_term
      t.string :kind
      t.boolean :priority, default: false
      t.datetime :active_from

      t.timestamps null: false
    end
    add_index :referrer_sources, :session_id

    create_table :referrer_sources_tracked_objects do |t|
      t.integer :user_id
      t.integer :source_id
      t.datetime :linked_at
      t.integer :trackable_id
      t.string  :trackable_type

      t.timestamps null: false
    end
    add_index :referrer_sources_tracked_objects, [:trackable_type, :trackable_id], name: 'referrer_sources_tracked_objects_ta'
    add_index :referrer_sources_tracked_objects, :user_id
    add_index :referrer_sources_tracked_objects, :source_id
  end
end
