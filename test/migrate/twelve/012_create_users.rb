class CreateUsers < ActiveRecord::Migration[5.0]
  def self.up
    create_table "users", force: true do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :users
  end
end
