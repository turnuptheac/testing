class CreateFlashcards < ActiveRecord::Migration[5.0]
  def change
    create_table :flashcards do |t|
      t.integer :bin
      t.string :question
      t.string :answer
      t.datetime :scheduled_time_to_revisit
      t.integer :times_wrong

      t.timestamps
    end
  end
end
