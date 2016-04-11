class CleanUpOrphanedIndexes < ActiveRecord::Migration[5.0]
  def change
    if index_exists? :dictionary_words, :hash_integer
      remove_index :dictionary_words, :hash_integer
    end
    if index_exists? :dictionary_words, :hash_vowels
      remove_index :dictionary_words, :hash_vowels
    end
  end
end

