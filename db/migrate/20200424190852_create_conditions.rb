class CreateConditions < ActiveRecord::Migration[5.2]
  def change
    create_table :conditions do |t|

      t.timestamps
    end
  end
end
