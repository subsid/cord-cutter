class CreateStreamPackages < ActiveRecord::Migration[5.2]
  def change
    create_table :stream_packages do |t|
      t.string :name
      t.integer :cost

      t.timestamps
    end
  end
end
