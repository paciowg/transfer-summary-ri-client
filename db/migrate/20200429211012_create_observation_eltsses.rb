class CreateObservationEltsses < ActiveRecord::Migration[5.2]
  def change
    create_table :observation_eltsses do |t|

      t.timestamps
    end
  end
end
