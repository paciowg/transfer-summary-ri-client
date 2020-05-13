class CreatePatients < ActiveRecord::Migration[5.2]
  def change
    create_table :patients do |t|

      t.timestamps
    end
  end
end
