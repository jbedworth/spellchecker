class RemoveHashVowelsFromDictionaryWord < ActiveRecord::Migration[5.0]
  def change
    remove_column :dictionary_words, :hash_vowels, :string
  end
end
