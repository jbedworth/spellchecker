class AddConsonantsToDictionaryWord < ActiveRecord::Migration[5.0]
  def change
    remove_column :dictionary_words, :hash_integer, :integer
    add_column :dictionary_words, :hash_vowels, :string

    add_index :dictionary_words, :hash_vowels
  end
end
