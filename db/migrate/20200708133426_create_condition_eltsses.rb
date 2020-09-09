class CreateConditionEltsses < ActiveRecord::Migration[5.2]
  def change
    create_table :condition_eltsses do |t|

      t.timestamps
    end
  end
end
