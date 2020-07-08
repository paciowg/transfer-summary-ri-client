class CreateContracts < ActiveRecord::Migration[5.2]
  def change
    create_table :contracts do |t|

      t.timestamps
    end
  end
end
