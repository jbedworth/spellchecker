class CreateDictionaryWords < ActiveRecord::Migration[5.0]
  def change
    add_index :dictionary_words, :hash_string
    add_index :dictionary_words, :word, :unique => true
  end
end
