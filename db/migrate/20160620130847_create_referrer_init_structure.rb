class CreateReferrerInitStructure < ActiveRecord::Migration
  def change
    create_table :referrer_users do |t|
      t.integer :linked_object_id
      t.string :linked_object_type

      t.timestamps null: false
    end

    create_table :referrer_sessions do |t|
      t.integer :user_id
      t.datetime :active_until

      t.timestamps null: false
    end

    create_table :referrer_sources do |t|
      t.integer :session_id
      t.string :referrer
      t.string :entry_point
      t.string :utm_source
      t.string :utm_campaign
      t.string :utm_medium
      t.string :utm_content
      t.string :utm_term
      t.boolean :priority, default: false

      t.timestamps null: false
    end

    add_index :referrer_users, :linked_object_id
    add_index :referrer_sessions, :user_id
    add_index :referrer_sources, :session_id
  end
end
