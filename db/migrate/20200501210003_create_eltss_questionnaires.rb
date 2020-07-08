class CreateEltssQuestionnaires < ActiveRecord::Migration[5.2]
  def change
    create_table :eltss_questionnaires do |t|

      t.timestamps
    end
  end
end
