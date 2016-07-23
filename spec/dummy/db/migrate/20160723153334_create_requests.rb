class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.text :body
      t.text :email
      t.timestamps null: false
    end
  end
end
