class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :imdbID
      t.string :title
      t.string :year

      t.timestamps
    end
  end
end
