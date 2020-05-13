class CreateObservations < ActiveRecord::Migration[5.2]
  def change
    create_table :observations do |t|

      t.timestamps
    end
  end
end
