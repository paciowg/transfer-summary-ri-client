class CreateRelatedPeople < ActiveRecord::Migration[5.2]
  def change
    create_table :related_people do |t|

      t.timestamps
    end
  end
end
