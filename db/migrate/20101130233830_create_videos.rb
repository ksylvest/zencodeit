class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.references :user

      t.string :name
      t.text :description

      t.string :state

      t.attachment :encoding
      t.attachment :preview

      t.timestamps
    end

    add_index :videos, :user_id
  end
end
