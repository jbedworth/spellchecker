class RemoveHashVowelsFromDictionaryWord < ActiveRecord::Migration[5.0]
  def change
    if column_exists? :dictionary_words, :hash_vowels
      remove_column :dictionary_words, :hash_vowels, :string
    end
  end
end
