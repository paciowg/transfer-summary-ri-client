class CreateEpisodeOfCares < ActiveRecord::Migration[5.2]
  def change
    create_table :episode_of_cares do |t|

      t.timestamps
    end
  end
end
