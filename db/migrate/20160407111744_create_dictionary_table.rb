class CreateDictionaryTable < ActiveRecord::Migration[5.0]
  def change
    create_table :dictionary_words do |t|
      t.string :word
      t.string :hash_string
    end
  end
end
