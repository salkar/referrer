class CreateSupports < ActiveRecord::Migration
  def change
    create_table :supports do |t|
      t.text :text
      t.timestamps
    end
  end
end
