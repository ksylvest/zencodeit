class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid

      t.timestamps
    end

    add_index :users, %i[provider uid]
  end
end
