class CreateSupports < ActiveRecord::Migration[5.0]
  def change
    create_table :supports do |t|
      t.text :text
      t.timestamps
    end
  end
end
