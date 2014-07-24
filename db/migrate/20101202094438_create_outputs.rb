class CreateOutputs < ActiveRecord::Migration
  def change
    create_table :outputs do |t|
      t.references :video
      t.integer :zencoder_id
      t.string :state

      t.timestamps
    end

    add_index :outputs, :video_id
    add_index :outputs, :zencoder_id
  end
end
