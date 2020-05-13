class CreateRiskAssessments < ActiveRecord::Migration[5.2]
  def change
    create_table :risk_assessments do |t|

      t.timestamps
    end
  end
end
